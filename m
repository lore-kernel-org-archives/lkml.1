Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYKCDF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYKCDF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 22:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbYKCDFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 22:05:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:40042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbYKCDFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 22:05:11 -0500
Message-ID: <490E6A38.2060102@kernel.org>
Date: Mon, 03 Nov 2008 12:04:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, lists@ku-gbr.de
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <20081006211906.GA31148@anita.doom> <20081006212307.GA881@anita.doom> <48EAB535.8010203@kernel.org> <20081007060357.GA16761@anita.doom> <48EB1993.1030606@panasas.com> <20081008080848.GA20525@anita.doom> <48F3088C.9010002@kernel.org> <48F308E8.4030503@kernel.org> <20081013142951.GB23124@anita.doom> <48F58A96.8040406@kernel.org> <20081027092208.GC16491@anita.doom>
In-Reply-To: <20081027092208.GC16491@anita.doom>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Nov 2008 03:05:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Kletschke wrote:
> Hello Tejun!
> 
> After my short reply I had a 2.6.27 running with
> 
> [-- Attachment #2: sata_nv-nf2-hrst-debug-take2.patch --]
> 
> fine so far. It bootet immediately at any time I powercycled the
> machine. Hot, cold and reboot seems to be no problem, no
> /var/log/messages flooding also.
> 
> I just wanted to inform you, whatever the investigations result into, on
> _my_ machine this incarnation is just fine.

Great.  My test machine just confirmed the fix too (my first purchase
was borked so I had to get another one so the delay).  I'll forward the
fix to upstream.

Thanks a lot.

-- 
tejun
