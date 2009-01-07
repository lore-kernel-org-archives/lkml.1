Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbZAGXr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbZAGXr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZAGXrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:47:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49609 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZAGXrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:47:15 -0500
Date: Wed, 7 Jan 2009 18:47:12 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
In-Reply-To: <alpine.DEB.1.10.0901071844160.23456@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0901071846430.23456@gandalf.stny.rr.com>
References: <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com> <20090107223317.GB27629@elte.hu>
 <4965331E.8090202@novell.com> <alpine.DEB.1.10.0901071806240.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071529530.3057@localhost.localdomain> <alpine.DEB.1.10.0901071844160.23456@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 7 Jan 2009, Steven Rostedt wrote:
> 
> True. I need to keep looking at the code that is posted. In -rt, we force 
> the fast path into the slowpath as soon as another task fails to get the 
> lock. Without that, as you pointed out, the code can be racy.

I mean we force the fast unlock path into the slow path as soon as another 
task fails to get the lock.

-- Steve

