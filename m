Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbXJAVwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbXJAVwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXJAVwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:52:38 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45868 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753444AbXJAVwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:52:37 -0400
Date: Mon, 1 Oct 2007 14:52:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: a.p.zijlstra@chello.nl, nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dgc@sgi.com, jens.axboe@oracle.com
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
In-Reply-To: <20071001144543.4cfa1e44.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710011448120.22169@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <20070919033643.763818012@sgi.com>
 <200709280742.38262.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
 <1191002119.18147.80.camel@lappy> <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
 <1191003950.18147.85.camel@lappy> <20070929011311.8b51dedb.akpm@linux-foundation.org>
 <1191055632.18147.101.camel@lappy> <20070929020049.f73f4aea.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0710011354480.19779@schroedinger.engr.sgi.com>
 <20071001143047.238dfe49.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0710011432300.20107@schroedinger.engr.sgi.com>
 <20071001144543.4cfa1e44.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Andrew Morton wrote:

> Ah.  So the already-dropped
> slub-exploit-page-mobility-to-increase-allocation-order.patch was the
> culprit?

Yes without that patch SLUB will no longer take special action if antifrag 
is around.

