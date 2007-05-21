Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbXEURGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbXEURGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762133AbXEURGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:06:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36590 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761957AbXEURGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:06:40 -0400
Date: Mon, 21 May 2007 10:06:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
In-Reply-To: <20070520092552.GA7318@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0705211004340.26282@schroedinger.engr.sgi.com>
References: <20070518040854.GA15654@wotan.suse.de>
 <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com>
 <20070519012530.GB15569@wotan.suse.de> <20070519181501.GC19966@holomorphy.com>
 <20070520052229.GA9372@wotan.suse.de> <20070520084647.GF19966@holomorphy.com>
 <20070520092552.GA7318@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Nick Piggin wrote:

> I _am_ considering the average case, and I consider the aligned structure
> is likely to win on average :) I just don't have numbers for it yet.

I'd be glad too if you could get some numbers. I did some benchmarking a 
few weeks ago on x86_64 and I found only a very minimal performance drop 
if the calculation was simplified. 

Note also that a smaller structure means that more page structs can be 
covered by a certain amount of cachelines. Doing the alignment may cause 
more cacheline misses.

