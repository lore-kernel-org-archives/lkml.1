Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYA1DTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYA1DTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 22:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYA1DTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 22:19:47 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:53266 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbYA1DTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 22:19:47 -0500
Subject: Re: Problem with ata layer in 2.6.24
From: Kasper Sandberg <lkml@metanurb.dk>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200801272122.21823.gene.heskett@gmail.com>
References: <200801272122.21823.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 04:19:03 +0100
Message-Id: <1201490343.2684.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-01-27 at 21:22 -0500, Gene Heskett wrote:
> Greeting;
> 
<snip>
> None were logged during the time I was running an -rc7 or -rc8.
> 
> The previous hits on this resulted in the udma speed being downgraded 
> till it was actually running in pio just before the freeze that 
> required the hardware reset button.
> 
> I'll reboot to -rc8 right now and resume.  If its the drive, I should see it.
> If not, then 2.6.24 is where I'll point the finger.
> 
> Idea's anyone?
I believe there is some sort of bug in libata, not just for this kernel
version.

i run a fileserver with .20, and i get these resets a few times a day..
no freezes though... except when its in progress, then all IO freezes
and locks up applications using it.. but it passes after ~30sec.

i know that since ubuntu started shipping with libata by default for
IDE, a large number of people are seeing these intermittant freezes
aswell(which passes after half a minute or less).

i reported this before, however as far as i know, no reason, and much
less a fix, has been found.

it would be great to get this solved though.


> 
> -- 
> Cheers, Gene
> "There are four boxes to be used in defense of liberty:
>  soap, ballot, jury, and ammo. Please use in that order."
> -Ed Howdershelt (Author)
> Yow!  Am I in Milwaukee?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

