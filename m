Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbYHUQs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbYHUQs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYHUQsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:48:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53660 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYHUQsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:48:18 -0400
Date: Thu, 21 Aug 2008 09:48:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4
	released
Message-ID: <20080821164809.GL6690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <1219313231.8651.101.camel@twins> <48AD4A0B.8020805@s5r6.in-berlin.de> <1219316568.8651.107.camel@twins> <20080821114745.GD21089@linux.vnet.ibm.com> <alpine.LFD.1.10.0808210845280.3487@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808210915590.3487@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808210915590.3487@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 09:18:29AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 21 Aug 2008, Linus Torvalds wrote:
> > 
> > No, I haven't seen the drafts
> 
> Ok, I have looked at the draft now, and I don't think I was overly 
> pessimistic.
> 
> If I read it right, all the memory ordering operations are defined for 
> _single_ objects. So if you want to do the kernel kind of memory ordering 
> where you specify ordering requirements independently of the actual 
> accesses (perhaps because the accesses are in some helper function that 
> doesn't care, but then you want to "finalize" the thing by stating a 
> sequence point), it seems to be impossible with current drafts.

You are looking for atomic_fence() on page 1168 (1154 virtual) of the
most recent draft.  The current semantics are not correct, but this is
being worked.  And yes, it does currently have a variable associated with
it, but it acts as a bare fence nevertheless.  There is a proposal to
drop the variable.  As you said in a previous email, design by committee.

> Oh, well. Nothing lost. I didn't expect the thing to work.

;-)

							Thanx, Paul
