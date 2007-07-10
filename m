Return-Path: <linux-kernel-owner+w=401wt.eu-S1761126AbXGJBwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761126AbXGJBwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbXGJBvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:51:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58174 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755061AbXGJBvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:51:53 -0400
Date: Mon, 9 Jul 2007 18:51:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <4692E3BF.9010305@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0707091849590.2860@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com>
 <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org>
 <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
 <4692E3BF.9010305@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Nick Piggin wrote:

> > O(n) memory savings? What is that?
> 
> Allocate n things and your memory waste is proportional to n (well that's
> O(n) waste, so I guess by savings I mean that SLOB's memory saving compared
> to SLUB are proportional to n).

n is the size of the object?

Its linear correlated to the object size. It does not grow 
exponentially as object size grows. Waste in the kmalloc array in the 
worst case is < objsize.

