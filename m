Return-Path: <linux-kernel-owner+w=401wt.eu-S1764784AbXGJSqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764784AbXGJSqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbXGJSqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:46:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37165 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754647AbXGJSqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:46:03 -0400
Date: Tue, 10 Jul 2007 11:46:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       kenchen@google.com, jschopp@austin.ibm.com, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       y-goto@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans -- anti-fragmentation
In-Reply-To: <20070710130356.GG8779@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0707101142340.11906@schroedinger.engr.sgi.com>
References: <20070710102043.GA20303@skynet.ie> <20070710130356.GG8779@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Nick Piggin wrote:

> I realise in your pragmatic approach, you are encouraging users to
> put fallbacks in place in case a higher order page cannot be allocated,
> but I don't think either higher order pagecache or higher order slubs
> have such fallbacks (fsblock or a combination of fsblock and higher
> order pagecache could have, but...).

We have run mm kernels for month now without the need of a fallback. I 
purpose of ZONE_MOVABLE was to guarantee that higher order pages could be 
reclaimed and thus make the scheme reliable?

The experience so far shows that the approach works reliably. If there are 
issues then they need to be fixed. Putting in workarounds in other places 
such as in fsblock may just be hiding problems if there are any.

