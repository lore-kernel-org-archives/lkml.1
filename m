Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752293AbYLQUcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbYLQUcj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 15:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYLQUca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 15:32:30 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:53818 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751304AbYLQUc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 15:32:29 -0500
Date: Wed, 17 Dec 2008 21:32:27 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FPU emulation broken in 2.6.28-rc8 ?
Message-ID: <20081217203227.GA10899@bitwizard.nl>
References: <20081217085620.GA20184@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217085620.GA20184@bitwizard.nl>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

It took me a while to admit to this possiblity, but indeed, it 
seems that FPU emulation is broken again. It's happened two times
before. 2.6.27 is NOT affected. 

	Roger.

On Wed, Dec 17, 2008 at 09:56:20AM +0100, Rogier Wolff wrote:
> I'm getting messages similar to: 
> 
> FPU emulator: unknown prefix byte 0x00,
> FPU emulator: probably due to self-modifying code (emulation impossible)
> FPU ........: internal error type 0x0126
> At 00000017:0000
>  SW: b=1 st=0 es=1 sf=1 cc=0010 ef=111111
>  CW: ic=0 rc=00 pc=11 ien=0     ef=111111
> 
> 
> (I cut-pasted the above from something I found on google, relating
> to 2.4.7, where the FPU emulator was fixedin 2.4.8. 
> In my case "internal error" was 126, just like in '2001, In
> my case I have "at 17:0", wwhereas in '01 it was reported "at
> 23:206". And the formatting changed a bit, which I corrected. 
> I don't have all the different flags available. If this doesn't
> provide enough hints, I'll have to figure those out fro you again.
> 
> I'm trying to set up a thin client, which runs on a geode, which
> apparently doesn't have a FPU.... (/proc/cpuinfo mentions the flag 
> "fpu", what does THAT mean?)
> 
> Oh, it seems as if some "state" is involved. booting init=/bin/bash
> works, but allowing the system to boot a bit further leads to the
> login shell (/bin/bash) getting killed due to the FPU emulator 
> problem.... 
> 
> 	Roger. 
> 
> -- 
> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
> **    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
> *-- BitWizard writes Linux device drivers for any device you may have! --*
> Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
> Does it sit on the couch all day? Is it unemployed? Please be specific! 
> Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
