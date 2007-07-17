Return-Path: <linux-kernel-owner+w=401wt.eu-S936324AbXGQVQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936324AbXGQVQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbXGQVQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:16:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50406 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758957AbXGQVQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:16:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 23:24:31 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org> <87odiag45q.fsf@jbms.ath.cx> <Pine.LNX.4.64.0707171335180.2467@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707171335180.2467@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172324.33285.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 22:37, david@lang.hm wrote:
> On Tue, 17 Jul 2007, Jeremy Maitin-Shepard wrote:
> 
> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >
> > [snip]
> >
> >>> Rafael, for those of us who aren't thoroughly familiar with all the ins
> >>> and outs of the ACPI spec, could you please summarize a list of the
> >>> ACPI calls needed in the second and third cases above?  Indicate which
> >>> ones need to be done from within the original kernel and which should
> >>> be done from within a kexec'd hibernation kernel.
> >
> >> Sure.
> >
> >> In the third case (ie. transition to S4) we are supposed to do the following:
> >
> >> (1) Upon entering the sleep state, which IMO can be done _after_ the image
> >>     has been saved:
> >
> > I assume you mean "in order to enter the sleep state", rather than "upon
> > entering the sleep state".  I still don't understand what you mean by
> > "which IMO can be done _after_ the image has been saved"; as far as I
> > understand, the last step of this process, "make the platform enter S4",
> > is almost like a shutdown as far as the kernel is concerned (except for
> > the tiny detail of having to call those special ACPI methods on resume);
> > consequently, it would seem that nothing can be done after that step.
> >
> >>   * figure out which devices can wake up
> >>   * put devices into low power states (wake-up devices are placed in the Dx
> >>     states compatible with the wake capability, the others are powered off)
> 
> this can't be done by the image-saving kernel if that kernel doesn't know 
> about the device.

Good observation. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
