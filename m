Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbXJBIGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbXJBIGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXJBIGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:06:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:44852 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbXJBIGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:06:00 -0400
Date: Tue, 2 Oct 2007 10:05:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: clockevents: fix resume logic
Message-ID: <20071002080555.GB5743@atrey.karlin.mff.cuni.cz>
References: <200709111323.56030.rjw@sisk.pl> <20070911042228.1ef690e0.akpm@linux-foundation.org> <200709111409.13796.rjw@sisk.pl> <20070911112531.80bac380.akpm@linux-foundation.org> <1189535883.5235.13.camel@chaos> <20070911114417.3f6e9e1b.akpm@linux-foundation.org> <1189540321.5235.21.camel@chaos> <20070912021248.0c653525.akpm@linux-foundation.org> <20070917183737.GB5966@ucw.cz> <1190451047.4035.29.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190451047.4035.29.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2007-09-17 at 18:37 +0000, Pavel Machek wrote:
> > > That's a bit tricky because hitting the keyboard is what unsticks things. 
> > > And the video is black after resume-from-RAM (has always been thus) and we
> > 
> > Ok, can we try to fix the video issue for you? That should make the
> > development easier... I assume you tried s2ram from suspend.sf.net,
> > and no combination of switches helped?
> 
> I have the same issue. Blank screen after suspend to ram. Hibernate
> works.

So, you have tried s2ram with all the different options, and none of
them can restore the screen? (s2ram is available at suspend.sf.net.)
i386 emulator is needed to restore the screen on many machines, that's
why we can't do it from kernel :-(.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
