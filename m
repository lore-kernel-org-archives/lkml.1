Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYLNDvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYLNDvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 22:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYLNDuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 22:50:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:49172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbYLNDuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 22:50:55 -0500
Message-ID: <494482C7.6080209@kernel.org>
Date: Sun, 14 Dec 2008 12:51:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Erich Mounce <echto1@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <48EAB535.8010203@kernel.org> <20081007060357.GA16761@anita.doom> <48EB1993.1030606@panasas.com> <20081008080848.GA20525@anita.doom> <48F3088C.9010002@kernel.org> <48F308E8.4030503@kernel.org> <20081013142951.GB23124@anita.doom> <48F58A96.8040406@kernel.org> <20081027092208.GC16491@anita.doom> <490E6A38.2060102@kernel.org> <20081103083222.GA23221@anita.doom> <loom.20081214T004001-31@post.gmane.org>
In-Reply-To: <loom.20081214T004001-31@post.gmane.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 14 Dec 2008 03:50:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erich Mounce wrote:
> I'm experiencing this issue with CD-RWs only.  Power cycling allows
> me to eject the CD-RW.  I'm using an ASUS G50V laptop with kernel
> 2.6.27-gentoo-r4.
> 
> lspci | grep ATA
> 00:1f.2 SATA controller: Intel Corporation Mobile SATA AHCI Controller (rev 03)
> dmesg output:
> [  189.184114] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
>  frozen
> [  189.184160] ata2.00: cmd a0/01:00:00:00:10/00:00:00:00:00/a0 tag 0 dma 
> 4096 in
> [  189.184164]          cdb 28 00 00 05 70 74 00 00  02 00 00 00 00 00 00 00
> [  189.184168]          res 40/00:03:00:fe:00/00:00:00:00:00/a0 Emask 
> 0x4 (timeout)

It's a different failure on a different controller.  Can you please
file a bug report on bugzilla.kernel.org and...

1. Reproduce the problem with kernel-2.6.28-rc8.
2. Attach boot and the failure kernel log.
3. Attach the output of "lspci -nn".

Thanks.

-- 
tejun
