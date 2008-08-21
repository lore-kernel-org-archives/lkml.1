Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbYHULDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbYHULDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYHULCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:02:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:42900 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbYHULCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:02:53 -0400
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger
	2.6.27-rc4	released
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <48AD4A0B.8020805@s5r6.in-berlin.de>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
	 <1219313231.8651.101.camel@twins>  <48AD4A0B.8020805@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 13:02:48 +0200
Message-Id: <1219316568.8651.107.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 12:57 +0200, Stefan Richter wrote:
> Peter Zijlstra wrote:
> > On Wed, 2008-08-20 at 20:50 -0600, jmerkey@wolfmountaingroup.com wrote:
> > 
> >>  volatiles left in the code due to the previously stated
> >>  (and still present) severe breakage of the GNU compiler with SMP 
> >>  shared data.  most of the barrier() functions are just plain broken
> >>  and do not result in proper compiler behavior in this tree. 
> > 
> > Can you provide explicit detail?
> > 
> > By using barrier() the compiler should clobber all its memory and
> > registers therefore forcing a write/reload of the variable.
> 
> I hope Jeff didn't try mere barrier()s only.  smp_wmb() and smp_rmb()
> are the more relevant barrier variants for mdb, from what I remember
> when I last looked at it.

Sure, but volatile isn't a replacement for memory barriers.

