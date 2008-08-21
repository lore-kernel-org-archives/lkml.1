Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYHUQUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYHUQUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYHUQUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:20:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbYHUQUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:20:09 -0400
Date: Thu, 21 Aug 2008 09:18:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4
 released
In-Reply-To: <alpine.LFD.1.10.0808210845280.3487@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808210915590.3487@nehalem.linux-foundation.org>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <1219313231.8651.101.camel@twins> <48AD4A0B.8020805@s5r6.in-berlin.de> <1219316568.8651.107.camel@twins> <20080821114745.GD21089@linux.vnet.ibm.com>
 <alpine.LFD.1.10.0808210845280.3487@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Aug 2008, Linus Torvalds wrote:
> 
> No, I haven't seen the drafts

Ok, I have looked at the draft now, and I don't think I was overly 
pessimistic.

If I read it right, all the memory ordering operations are defined for 
_single_ objects. So if you want to do the kernel kind of memory ordering 
where you specify ordering requirements independently of the actual 
accesses (perhaps because the accesses are in some helper function that 
doesn't care, but then you want to "finalize" the thing by stating a 
sequence point), it seems to be impossible with current drafts.

Oh, well. Nothing lost. I didn't expect the thing to work.

		Linus
