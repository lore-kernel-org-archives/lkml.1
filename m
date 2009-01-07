Return-Path: <linux-kernel-owner+w=401wt.eu-S1763732AbZAGXRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763732AbZAGXRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763336AbZAGXOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:14:38 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:60675 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932582AbZAGXOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:14:34 -0500
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>, Andi Kleen <andi@firstfloor.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <1231368665.3470.513.camel@hermosa.site>
References: <1231283778.11687.136.camel@twins>
	 <1231329783.11687.287.camel@twins>
	 <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231347442.11687.344.camel@twins>
	 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
	 <20090107210923.GV2002@parisc-linux.org>
	 <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com>
	 <20090107223317.GB27629@elte.hu>  <1231368665.3470.513.camel@hermosa.site>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Wed, 07 Jan 2009 23:14:24 +0000
Message-Id: <1231370064.3470.516.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 15:51 -0700, Peter W. Morreale wrote:
> On Wed, 2009-01-07 at 23:33 +0100, Ingo Molnar wrote:
> > * Gregory Haskins <ghaskins@novell.com> wrote:
> > 
> > > Can I ask a simple question in light of all this discussion?
> > > 
> > > "Is get_task_struct() really that bad?"
> > 
> > it dirties a cacheline and it also involves atomics.
> > 
> > Also, it's a small design cleanliness issue to me: get_task_struct() 
> > impacts the lifetime of an object - and if a locking primitive has 
> > side-effects on object lifetimes that's never nice.
> > 
> 
> True, but it's for one iteration * NR_CPUS, max.
> 
> Best,
> -PWM

Never mind.  Bogus argument.  

That's why we have you Big Guns out there... - To keep us rif-raf in
line... 

:-)

Best,
-PWM

