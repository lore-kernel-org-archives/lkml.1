Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbXJBUMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbXJBUMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 16:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXJBUMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 16:12:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37304 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661AbXJBUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:12:35 -0400
Date: Tue, 2 Oct 2007 13:11:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tglx@linutronix.de, torvalds@linux-foundation.org, mingo@elte.hu,
       ak@suse.de, greg@kroah.com, rusty@rustcorp.com.au, sam@ravnborg.org,
       hpa@zytor.com, peterz@infradead.org, venkatesh.pallipadi@intel.com,
       travis@sgi.com, avi@qumranet.com, jason.wessel@windriver.com,
       jeremy@goop.org, glommer@gmail.com, chrisw@sous-sol.org,
       clameter@sgi.com, ebiederm@xmission.com, anil.s.keshavamurthy@intel.com,
       zach@vmware.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-Id: <20071002131131.6066eabe.akpm@linux-foundation.org>
In-Reply-To: <200710022212.15219.rjw@sisk.pl>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
	<alpine.LRH.0.999.0710021019310.23586@www.tglx.de>
	<200710022212.15219.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 22:12:13 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > Usage: x86-fixup-patches.py sourcepatch destpatch
> > 
> > source and dest can be the same.
> > 
> > A helper script to convert complete quilt series is here:
> > 	http://userweb.kernel.org/~tglx/x86/fixupseries.sh
> > 
> > If there is anything we can help with the transition, please do not
> > hesitate to ask.
> 
> Well, there are several arch-dependent power management patches in -mm queued
> up for merging.  Do I need to take care of converting them myself, or will that
> be done automatically, or ...?

It should be OK.  I'll wait until this lot hits Linus's tree and then I'll
redo the whole -mm patch queue.

The one problem with this is that I will have trouble repulling and remerging
the 81 subsystem tree which are part of -mm until their owners have fixed
everything up - I'll either need to temporarily drop them or will need to
fix them up with Thomas's script each time I fetch them.

But whatever - I'll sort it out..
