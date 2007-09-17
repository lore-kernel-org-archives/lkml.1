Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbXIVGpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbXIVGpX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 02:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbXIVGpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 02:45:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3573 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753926AbXIVGpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 02:45:07 -0400
Date: Mon, 17 Sep 2007 18:37:37 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: clockevents: fix resume logic
Message-ID: <20070917183737.GB5966@ucw.cz>
References: <200707220159.l6M1xBgH001236@hera.kernel.org> <200709111323.56030.rjw@sisk.pl> <20070911042228.1ef690e0.akpm@linux-foundation.org> <200709111409.13796.rjw@sisk.pl> <20070911112531.80bac380.akpm@linux-foundation.org> <1189535883.5235.13.camel@chaos> <20070911114417.3f6e9e1b.akpm@linux-foundation.org> <1189540321.5235.21.camel@chaos> <20070912021248.0c653525.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912021248.0c653525.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok, here we are. The bad one uses C2 which stops the local apic on the
> > VAIO. I suspect we end up in the suspend/resume with going into C2
> > without the broadcast active.
> > 
> > Can you try to get the output of SysRq-Q during the "it needs help from
> > keyboard" period ?
> > 
> 
> That's a bit tricky because hitting the keyboard is what unsticks things. 
> And the video is black after resume-from-RAM (has always been thus) and we

Ok, can we try to fix the video issue for you? That should make the
development easier... I assume you tried s2ram from suspend.sf.net,
and no combination of switches helped?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
