Return-Path: <linux-kernel-owner+w=401wt.eu-S934481AbZJIVed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481AbZJIVed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934462AbZJIVec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:34:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934192AbZJIVeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:34:31 -0400
Date: Fri, 9 Oct 2009 14:33:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Tony Lindgren <tony@atomide.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
Subject: Re: [GIT PULL] omap fixes for v2.6.32-rc3
Message-Id: <20091009143327.783b33c3.akpm@linux-foundation.org>
In-Reply-To: <20091009192642.GB32084@suse.de>
References: <20091007185112.GJ7899@atomide.com>
	<94a0d4530910081429m7ad88b43q38245109f3252078@mail.gmail.com>
	<20091008214140.GJ7417@atomide.com>
	<94a0d4530910081513w1a919dc2s50eca41966a2261d@mail.gmail.com>
	<94a0d4530910081520t66ce7567xe142979a35b1245@mail.gmail.com>
	<20091008232603.GB25892@atomide.com>
	<94a0d4530910090508o1e3d19cew881d2eb348199674@mail.gmail.com>
	<20091009144840.GA9561@suse.de>
	<94a0d4530910091029p12f8c28fve91e95db533e78e5@mail.gmail.com>
	<20091009192642.GB32084@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009 12:26:42 -0700
Greg KH <gregkh@suse.de> wrote:

> > >
> > > What kind of issues? __Why would I be interested, where is the problem?
> > 
> > The obvious-brain-dead-duh kind of issues, like this one.
> > 
> > The problem is that OMAP devices (like beagleboard) are not booting
> > correctly right now because of a wrong merge. It has been identified,
> > tested, and acked, but nobody has picked it up for a pull request, so
> > it's not clear it will be on -rc4.
> 
> Has the patches been sent from the maintainer to Linus?
> 
> Who is the maintainer?  Who normally sends this stuff?
> 
> > To me it's not clear who should push the patch, it seems it doesn't
> > belong on linux-omap, so Tony is pushing it through linux-mmc, which I
> > don't think is the right place. They should be handling mmc-related
> > issues, not obvious breakage.
> 
> Well, mmc related breakage is fine to handle :)
> 
> > In order to keep the engines oiled I think there must be a process to
> > flag obvious generic breakage so it's immediately picked; maybe an
> > 'obvious-fixes' tree, or a 'simple-fixes' that has 'trivial',
> > 'includecheck', and similar, or maybe nothing needs to be done. Up to
> > you to decide.
> 
> Andrew usually sends stuff like this at times.

yeah, when in doubt, send it to me.  When not in doubt send it to me
anyway ;)

I'll take care of bugging the appropriate maintainer or merging it directly.

