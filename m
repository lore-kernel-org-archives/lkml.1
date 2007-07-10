Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbXGJUJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbXGJUJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbXGJUJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:09:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43734 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756015AbXGJUJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:09:04 -0400
Date: Tue, 10 Jul 2007 13:09:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>
Subject: Re: -mm merge plans for 2.6.23
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707101303450.22199@schroedinger.engr.sgi.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Andrew Morton wrote:

> slub-exploit-page-mobility-to-increase-allocation-order.patch
> slub-reduce-antifrag-max-order.patch
> 
>  These are slub changes which are dependent on Mel's stuff, and I have a note
>  here that there were reports of page allocation failures with these.  What's
>  up with that?

Those were fixed and all has been well since as far as I know.

>  Maybe I should just drop the 100-odd marginal-looking MM patches?  We're
>  simply not showing compelling reasons for merging them and quite a lot of them
>  are stuck in a 90% complete state.

As far as I can tell the antifrag patches are stable and are significantly 
enhancing various aspects of the VM and also make it more reliable. SLUB 
can use it to increase scalability. MM has been using order 3 allocs via 
SLUB for months now without a problem. Without the antifrag patches order 
1 allocs could cause OOMs.

It opens the door for functionality that we wanted for a long time such a 
memory unplug etc.

