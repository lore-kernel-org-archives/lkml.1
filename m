Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbYAJTwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbYAJTwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbYAJTwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:52:04 -0500
Received: from relay2.sgi.com ([192.48.171.30]:38009 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755450AbYAJTwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:52:03 -0500
Date: Thu, 10 Jan 2008 11:52:02 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <20080110195329.GB2120@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0801101151230.20926@schroedinger.engr.sgi.com>
References: <1199906151.6245.57.camel@cinder.waste.org>
 <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
 <1199919548.6245.74.camel@cinder.waste.org> <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
 <1199987366.5331.92.camel@cinder.waste.org>
 <alpine.LFD.1.00.0801101013310.3148@woody.linux-foundation.org>
 <1199990565.5331.130.camel@cinder.waste.org>
 <alpine.LFD.1.00.0801101124140.3148@woody.linux-foundation.org>
 <20080110195329.GB2120@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008, Andi Kleen wrote:

> I did essentially that for my GBpages hugetlbfs patchkit. GB pages are already
> beyond MAX_ORDER and increasing MAX_ORDER didn't seem attractive because
> it would require aligning the zones all to 1GB which would quite nasty.

I am very very interested in that work and I could not find it when I 
looked for it a couple of weeks back. Can you sent me a copy?

