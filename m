Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYLNAzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYLNAzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 19:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYLNAzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 19:55:08 -0500
Received: from main.gmane.org ([80.91.229.2]:39496 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbYLNAzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 19:55:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Erich Mounce <echto1@gmail.com>
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Date: Sun, 14 Dec 2008 00:49:04 +0000 (UTC)
Message-ID: <loom.20081214T004001-31@post.gmane.org>
References: <48EAB535.8010203@kernel.org> <20081007060357.GA16761@anita.doom> <48EB1993.1030606@panasas.com> <20081008080848.GA20525@anita.doom> <48F3088C.9010002@kernel.org> <48F308E8.4030503@kernel.org> <20081013142951.GB23124@anita.doom> <48F58A96.8040406@kernel.org> <20081027092208.GC16491@anita.doom> <490E6A38.2060102@kernel.org> <20081103083222.GA23221@anita.doom>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 98.246.88.7 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.18) Gecko/20081212 Firefox/2.0.0.18)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Kletschke <lists <at> ku-gbr.de> writes:

> 
> Am 2008-11-03 12:04 +0900 schrieb Tejun Heo:
> 
> > Great.  My test machine just confirmed the fix too (my first purchase
> 
> 
> 
> > was borked so I had to get another one so the delay).  I'll forward the
> 
> Oh my...
> 
> > fix to upstream.
> > 
> > Thanks a lot.
> 
> No Problem at all. If something gets borked - which absolutely is
> allowed to happen - I have fun to sort this out.
> 
> Regards, Konsti
> 

I'm experiencing this issue with CD-RWs only.  Power cycling allows me to eject
the CD-RW.  I'm using an ASUS G50V laptop with kernel 2.6.27-gentoo-r4.

lspci | grep ATA
00:1f.2 SATA controller: Intel Corporation Mobile SATA AHCI Controller (rev 03)

dmesg output:
[  189.184114] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
 frozen
[  189.184160] ata2.00: cmd a0/01:00:00:00:10/00:00:00:00:00/a0 tag 0 dma 
4096 in
[  189.184164]          cdb 28 00 00 05 70 74 00 00  02 00 00 00 00 00 00 00
[  189.184168]          res 40/00:03:00:fe:00/00:00:00:00:00/a0 Emask 
0x4 (timeout)
[  189.184176] ata2.00: status: { DRDY }
[  189.184191] ata2: hard resetting link
[  194.538122] ata2: link is slow to respond, please be patient (ready=0)
[  199.185071] ata2: COMRESET failed (errno=-16)
[  199.185087] ata2: hard resetting link
[  204.539127] ata2: link is slow to respond, please be patient (ready=0)
[  209.231125] ata2: COMRESET failed (errno=-16)
[  209.231153] ata2: hard resetting link
[  214.585124] ata2: link is slow to respond, please be patient (ready=0)
[  244.267114] ata2: COMRESET failed (errno=-16)
[  244.267130] ata2: limiting SATA link speed to 1.5 Gbps
[  244.267136] ata2: hard resetting link
[  249.315112] ata2: COMRESET failed (errno=-16)
[  249.315124] ata2: reset failed, giving up
[  249.315130] ata2.00: disabled
[  249.315153] ata2: EH complete


