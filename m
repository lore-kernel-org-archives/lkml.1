Return-Path: <linux-kernel-owner+w=401wt.eu-S1767381AbXCIQlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767381AbXCIQlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767384AbXCIQlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:41:05 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59355 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767381AbXCIQlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:41:04 -0500
Date: Fri, 9 Mar 2007 08:40:58 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: akpm@osdl.org, Marcelo Tosatti <marcelo@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>, mpm@selenic.com,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [SLUB 0/3] SLUB: The unqueued slab allocator V4
In-Reply-To: <Pine.LNX.4.64.0703091355520.16052@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0703090839540.7250@schroedinger.engr.sgi.com>
References: <20070307023502.19658.39217.sendpatchset@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0703081022040.1615@skynet.skynet.ie>
 <Pine.LNX.4.64.0703080836300.27191@schroedinger.engr.sgi.com>
 <20070308174004.GB12958@skynet.ie> <Pine.LNX.4.64.0703081135280.3130@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0703091355520.16052@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Mel Gorman wrote:

> I'm not sure what you mean by per-order queues. The buddy allocator already
> has per-order lists.

Somehow they do not seem to work right. SLAB (and now SLUB too) can avoid 
(or defer) fragmentation by keeping its own queues.
