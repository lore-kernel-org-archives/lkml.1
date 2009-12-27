Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZL1NKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZL1NKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 08:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZL1NKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 08:10:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56649 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZL1NKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 08:10:20 -0500
Date: Sun, 27 Dec 2009 11:18:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Arve Hj?nnev?g <arve@android.com>, Daniel Walker <dwalker@codeaurora.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org,
       Greg KH <greg@kroah.com>
Subject: Re: tree with htc dream support
Message-ID: <20091227101824.GB1478@ucw.cz>
References: <1260627482.20913.7.camel@desktop> <d6200be20912121434x1a247837w75c518ba20fe684f@mail.gmail.com> <20091213212504.GD5114@elf.ucw.cz> <d6200be20912142234ia050c67p34fd2672e7248170@mail.gmail.com> <20091227093537.GD11737@elf.ucw.cz> <20091227201514.GA29174@elf.ucw.cz> <a55d774e0912271220p1d102b1dr398e0524c9386702@mail.gmail.com> <20091227203704.GK11737@elf.ucw.cz> <20091227211322.GB29174@elf.ucw.cz> <a55d774e0912271646m1b82687cy427083e64e91e323@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0912271646m1b82687cy427083e64e91e323@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Switch smd code to the version in staging. Something to apply to
> > dream/ tree I'd say... and yes, it still works.
> 
> I think we might want to consider leaving at least the core smd code
> under mach-msm.

In the long run, I agree.

In the short run... the code is staging quality, so it should be in
staging... and you'll not have to mainain so huge diff. (-20 kLoc).

> To start with it's specific to the 7k/8k platform, not dream (though
> that may just be a quirk of how things are named in staging).  Also
> the lowest layers (proc_comm and smsm_state stuff) are required for
> clock control and basic power management to work -- they're kinda
> joined at the hip with the platform.  It seems weird to me to have the
> necessary bits to implement clock/power/pm outside of the mach/arch
> space.

Agreed, but... I don't see much effort merging 7k/8k patches. And I
believe its better to use code that's already in staging/ to keep
diffs small. Renames are easy with git, and yes, we'll need to do some
moving when code is clean enough.

But that's how staging/ works: all the code there will need to be
moved to the proper places...

> The higher level stuff (qmi, rpcrouter, smdtty, etc) could easily live
> elsewhere (though I'm not sure where the best space in the drivers
> hierarchy for them would be).

drivers/mfd? Yes, we'll have to rename once the code is clean enough.

	     	  	     	       	    	     	Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
