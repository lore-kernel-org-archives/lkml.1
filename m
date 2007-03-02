Return-Path: <linux-kernel-owner+w=401wt.eu-S2992577AbXCBRJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992577AbXCBRJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992627AbXCBRJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:09:37 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34802 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992577AbXCBRJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:09:37 -0500
Date: Fri, 2 Mar 2007 09:09:30 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       mingo@elte.hu, jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
In-Reply-To: <20070302083832.GF5557@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0703020909010.16719@schroedinger.engr.sgi.com>
References: <20070302054944.GE15867@wotan.suse.de>
 <Pine.LNX.4.64.0703012150290.1768@schroedinger.engr.sgi.com>
 <20070302060831.GF15867@wotan.suse.de> <Pine.LNX.4.64.0703012213130.1917@schroedinger.engr.sgi.com>
 <20070302062950.GG15867@wotan.suse.de> <Pine.LNX.4.64.0703012236160.1979@schroedinger.engr.sgi.com>
 <20070302071955.GA5557@wotan.suse.de> <Pine.LNX.4.64.0703012335250.13224@schroedinger.engr.sgi.com>
 <20070302081210.GD5557@wotan.suse.de> <Pine.LNX.4.64.0703020015080.14651@schroedinger.engr.sgi.com>
 <20070302083832.GF5557@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Nick Piggin wrote:

> > Oh just run a 32GB SMP system with sparsely freeable pages and lots of 
> > allocs and frees and you will see it too. F.e try Linus tree and mlock 
> > a large portion of the memory and then see the fun starting. See also 
> > Rik's list of pathological cases on this.
> 
> Ah, so your problem is lots of unreclaimable pages. There are heaps
> of things we can try to reduce the rate at which we scan those.

Well this is one possible sympton of the basic issue of having too many 
page structs. I wonder how long we can patch things up.

