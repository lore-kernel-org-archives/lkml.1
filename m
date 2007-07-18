Return-Path: <linux-kernel-owner+w=401wt.eu-S1763342AbXGRLKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763342AbXGRLKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXGRLKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:10:44 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:38496 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbXGRLKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:10:43 -0400
Date: Wed, 18 Jul 2007 12:10:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jim Crilly <jim@why.dont.jablowme.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Message-ID: <20070718111016.GA18716@srcf.ucam.org>
References: <200707151433.34625.rjw@sisk.pl> <200707161406.28539.rjw@sisk.pl> <20070716123849.GC14212@grifter.jdc.home> <200707161729.16440.rjw@sisk.pl> <Pine.LNX.4.64.0707162119500.19248@asgard.lang.hm> <20070717104231.GA32486@srcf.ucam.org> <Pine.LNX.4.64.0707170818460.19248@asgard.lang.hm> <20070718021817.GA13502@srcf.ucam.org> <Pine.LNX.4.64.0707172053280.19248@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707172053280.19248@asgard.lang.hm>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Hibernation considerations
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 08:54:24PM -0700, david@lang.hm wrote:
> On Wed, 18 Jul 2007, Matthew Garrett wrote:
> 
> >On Tue, Jul 17, 2007 at 08:19:32AM -0700, david@lang.hm wrote:
> >>On Tue, 17 Jul 2007, Matthew Garrett wrote:
> >>>Powering off rather than using S4 means you lose most wakeup device
> >>>support. That would be a functional regression compared to the current
> >>>code.
> >>
> >>only if the kexec isn't able to initialize those devices.
> >
> >If you aren't using ACPI, you probably don't know how to.
> 
> the current kexec patch to allow you to move back to the original kernel 
> requires ACPI be disabled to work.

Which means it isn't putting the hardware into S4, which means that you 
don't get the platform wakeup events.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
