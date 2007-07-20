Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbXGTVip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbXGTVip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbXGTVid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:38:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbXGTVib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:38:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Fri, 20 Jul 2007 23:46:34 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Milton Miller <miltonm@bga.com>,
       linux-pm <linux-pm@lists.linuxfoundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <Pine.LNX.4.44L0.0707201211450.3811-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707201211450.3811-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707202346.35901.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 July 2007 18:15, Alan Stern wrote:
> On Fri, 20 Jul 2007 david@lang.hm wrote:
> 
> > or the userspace helper functions that setup the instructions for the 
> > hibernate warn you if you are telling it to mount a filesystem that it 
> > knows is ext3 and is in use by the system going to sleep.
> 
> One can argue that the ext3 implementation is inadequate.  We should be
> able to give it a mount option requiring it to fail rather than play
> back the journal and write to the disk.
> 
> 
> > > What I've been trying to say from the very beginning is that the current
> > > frameworks _support_ hibernation a la ACPI S4 (although that's not exactly
> > > ACPI S4) and if we are going to introduce a new framework, then it should
> > > be designed to _support_ ACPI S4 fully _from_ _the_ _start_.
> > 
> > here is where there is some disagreement (although it may just be 
> > misunderstanding on the 'fully support' phrase)
> > 
> > it sounds like you are saying that the ACPI support requires a lot of work 
> > (the phrase I've seen some people use is a requirement to 'fix all the 
> > drivers'). we aren't wanting to have this work prevent the non-ACPI 
> > hibernation from progressing.
> 
> You have completely misunderstood.  That phrase "fix all the drivers" 
> has nothing whatsoever to do with ACPI.  It is a prerequisite for 
> removing the freezer.

Yes.

> And unless I'm mistaken, removing the freezer was the main reason for 
> doing all this kexec-style work in the first place.

Yes, that also is my impression.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
