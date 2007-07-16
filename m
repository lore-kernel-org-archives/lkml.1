Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbXGPTmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbXGPTmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXGPTmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:42:04 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:46376 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753504AbXGPTmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:42:03 -0400
Date: Mon, 16 Jul 2007 21:42:00 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-raid maillist <linux-raid@vger.kernel.org>,
       Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: raid5:md3: read error corrected ,  followed by ,  Machine Check Exception: .
Message-ID: <20070716194159.GB10124@bitwizard.nl>
References: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com> <20070715020454.19de921f@the-village.bc.nu> <Pine.LNX.4.64.0707141826580.16611@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707141826580.16611@filesrv1.baby-dragons.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 07:32:38PM -0700, Mr. James W. Laferriere wrote:
> >So your disk throws a fit
> 
> 	Actually it's brand new .  Infant mortallity ?  I at least have a 
> 	cold spare available .  So Yes I am replacing that puppy .  I'll drop it 
> into another system & give it the format command & see how much the user 
> bad block table grows .  I'll bet I'll get a table full overflow on it .

Manually keep both tables under supervision. I'd guess that if you
send it a format, it will update the factory table (and move the user
bad block table there). 

But most will retry writing to the bad sectors. And with a fully-fresh
copy of the data, it will still be readable, and the blocks will be
marked as ready-for-use, because that's better for performance....

> >And at some point at least 18 minutes after the raid incident you log
> >CPU problems.
> 
> 	I didn't notice the 18 Minute differance .  Drats .

I'm not sure how this happened, but the disk errror messages seem to have
been logged by syslog, and the MCEs seem to have been copied from the 
console: They don't have the date attached....?

	Roger.
-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
