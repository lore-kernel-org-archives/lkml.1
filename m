Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbXJJB1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbXJJB1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 21:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbXJJB05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 21:26:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58119 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149AbXJJB04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 21:26:56 -0400
Date: Tue, 9 Oct 2007 18:26:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Rik van Riel <riel@redhat.com>, Andi Kleen <ak@suse.de>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [13/18] x86_64: Allow fallback for the stack
In-Reply-To: <200710091846.22796.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710091825470.4500@schroedinger.engr.sgi.com>
References: <20071004035935.042951211@sgi.com> <200710082255.05598.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0710091138250.32162@schroedinger.engr.sgi.com>
 <200710091846.22796.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Nick Piggin wrote:

> > We already use 32k stacks on IA64. So the memory argument fail there.
> 
> I'm talking about generic code.

The stack size is set in arch code not in generic code.

> > > The solution has until now always been to fix the problems so they don't
> > > use so much stack. Maybe a bigger stack is OK for you for 1024+ CPU
> > > systems, but I don't think you'd be able to make that assumption for most
> > > normal systems.
> >
> > Yes that is why I made the stack size configurable.
> 
> Fine. I just don't see why you need this fallback.

So you would be ok with submitting the configurable stacksize patches 
separately without the fallback? 
