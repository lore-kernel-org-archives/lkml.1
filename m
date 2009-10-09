Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbZJIMRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbZJIMRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 08:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760685AbZJIMRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 08:17:17 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:28923 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760623AbZJIMRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 08:17:14 -0400
Message-ID: <4ACF296E.3000000@hp.com>
Date: Fri, 09 Oct 2009 08:15:42 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [RFC][PATCH] kmap_atomic_push
References: <1255016123.17055.17.camel@laptop>	 <20091008155344.GA11727@elte.hu> <1255019362.26976.311.camel@twins>	 <alpine.LFD.2.01.0910080945230.3432@localhost.localdomain>	 <Pine.LNX.4.64.0910081850270.4553@sister.anvils>  <4ACE674E.30403@hp.com> <1255042636.17055.33.camel@laptop>
In-Reply-To: <1255042636.17055.33.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> 
> The double unmap gives a preemption point, which sounds like a good
> thing to have, because your scheme could run for a long while without
> enabling preemption, which is badness.

Thanks, optimizing my loop, I forgot all about
the old long code path not preempting problem.

Now I have to love the patch for making it harder to be stupid :)
