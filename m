Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbXJBUQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbXJBUQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 16:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbXJBUQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 16:16:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbXJBUQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:16:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Date: Tue, 2 Oct 2007 22:31:24 +0200
User-Agent: KMail/1.9.5
Cc: tglx@linutronix.de, torvalds@linux-foundation.org, mingo@elte.hu,
       ak@suse.de, greg@kroah.com, rusty@rustcorp.com.au, sam@ravnborg.org,
       hpa@zytor.com, peterz@infradead.org, venkatesh.pallipadi@intel.com,
       travis@sgi.com, avi@qumranet.com, jason.wessel@windriver.com,
       jeremy@goop.org, glommer@gmail.com, chrisw@sous-sol.org,
       clameter@sgi.com, ebiederm@xmission.com, anil.s.keshavamurthy@intel.com,
       zach@vmware.com, linux-kernel@vger.kernel.org
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <200710022212.15219.rjw@sisk.pl> <20071002131131.6066eabe.akpm@linux-foundation.org>
In-Reply-To: <20071002131131.6066eabe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710022231.25941.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 2 October 2007 22:11, Andrew Morton wrote:
> On Tue, 2 Oct 2007 22:12:13 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > Usage: x86-fixup-patches.py sourcepatch destpatch
> > > 
> > > source and dest can be the same.
> > > 
> > > A helper script to convert complete quilt series is here:
> > > 	http://userweb.kernel.org/~tglx/x86/fixupseries.sh
> > > 
> > > If there is anything we can help with the transition, please do not
> > > hesitate to ask.
> > 
> > Well, there are several arch-dependent power management patches in -mm queued
> > up for merging.  Do I need to take care of converting them myself, or will that
> > be done automatically, or ...?
> 
> It should be OK.  I'll wait until this lot hits Linus's tree and then I'll
> redo the whole -mm patch queue.
> 
> The one problem with this is that I will have trouble repulling and remerging
> the 81 subsystem tree which are part of -mm until their owners have fixed
> everything up - I'll either need to temporarily drop them or will need to
> fix them up with Thomas's script each time I fetch them.
> 
> But whatever - I'll sort it out..

Many thanks!
