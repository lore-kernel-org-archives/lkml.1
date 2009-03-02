Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZCBWDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZCBWDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZCBWDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:03:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33281 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbZCBWDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:03:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/4] PM: Change suspend code ordering
Date: Mon, 2 Mar 2009 23:02:39 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>
References: <200902221837.49396.rjw@sisk.pl> <200903012325.53084.rjw@sisk.pl> <alpine.LFD.2.00.0903021246250.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903021246250.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903022302.42067.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Linus Torvalds wrote:
> 
> On Sun, 1 Mar 2009, Rafael J. Wysocki wrote:
> >
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Change the ordering of the suspend core code so that the platform
> > "prepare" callback is executed and the nonboot CPUs are disabled
> > after calling device drivers' "late suspend" methods.
> 
> Ok, ack on this whole series, looks fine.

Thanks!
 
> I'd like to see a 5/4 though:
> 
> > This change will allow us to rework the PCI PM core so that the power
> > state of devices is changed in the "late" phase of suspend (and
> > analogously in the "early" phase of resume)
> 
> .. doing this. Right now we have that hacky "avoid ACPI by doing a special 
> limited form of pci_set_power_state() and pci_enable() in the 
> early_resume. I'd love to see the actual PCI code cleanup too.

Sure, that's the next step, but I wanted to get the ack on the preliminary
patches first. :-)

Rafael
