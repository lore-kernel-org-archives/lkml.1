Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZJAJ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZJAJ6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbZJAJ6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:58:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085AbZJAJ6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:58:48 -0400
Date: Thu, 1 Oct 2009 11:57:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [origin tree build failure] [PATCH] thinkpad-acpi: Fix build
	on !CONFIG_THINKPAD_ACPI_HOTKEY_POLL
Message-ID: <20091001095743.GC26962@elte.hu>
References: <200909260519.n8Q5JrB6016778@hera.kernel.org> <20090927075254.GA20847@elte.hu> <20090927122828.GA24783@khazad-dum.debian.net> <alpine.LFD.2.00.0909272331520.5561@localhost.localdomain> <20090928153526.GA9231@elte.hu> <20090928194449.GA9469@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928194449.GA9469@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Mon, 28 Sep 2009, Ingo Molnar wrote:
> > * Len Brown <lenb@kernel.org> wrote:
> > > > > >  drivers/platform/x86/thinkpad_acpi.c    |  632 +++++++++++++++++++---------
> > > > > 
> > > > > -tip testing found that these changes caused a build failure 
> > > > > in drivers/platform/x86/thinkpad_acpi.c when 
> > > > > !CONFIG_THINKPAD_ACPI_HOTKEY_POLL - the fix is attached  below.
> > > > 
> > > > Fixed by a different patch, which will hit mainline soon....
> > > 
> > > Ingo,
> > > 2.6.32-rc1 should build fine* -- let me know if it doesn't.
> > > 
> > > thanks,
> > > Len Brown, Intel Open Source Technology Center
> > > 
> > > * module this message, which Henruque assures me will go away soon
> > > drivers/platform/x86/thinkpad_acpi.c:2225: warning: 
> > > ???tpacpi_hotkey_driver_mask_set??? defined but not used
> > 
> > well, the warning is fixed properly in my patch, as pointed out in the 
> > changelog. Have you read that?
> 
> Your patch will break the driver when the functionality that uses 
> tpacpi_hotkey_driver_mask_set() lands in mainline.  That functionality 
> is already in a subsystem tree waiting a push to Linus.
> 
> Of course, you had no way to know that, and I failed to convey that 
> detail (mostly because _I_ screwed up and forgot I had that patch 
> already applied) when I replied to you.  Sorry about that.
> 
> The patch adding that functionality had already been submitted at the 
> time you sent in your patch, and it will be merged through the 
> backlight tree very soon.  That patch couldn't arrive earlier because 
> it needed changes both in the backlight tree AND in the ACPI tree, and 
> nobody knew which tree would merge first.
> 
> Now that all dependencies (both from backlight and ACPI) are already 
> in mainline, I asked Richard Purdie to send it to Linus together with 
> his next batch of backlight updates.  That will silence the warning 
> about tpacpi_hotkey_driver_mask_set().

Ok, thanks for the update!

	Ingo
