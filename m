Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbYBESGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbYBESGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbYBESFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:05:55 -0500
Received: from relay2.sgi.com ([192.48.171.30]:53749 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752077AbYBESFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:05:54 -0500
Date: Tue, 5 Feb 2008 10:05:52 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: SLUB: Support for statistics to help analyze allocator behavior
In-Reply-To: <Pine.LNX.4.64.0802050923220.14675@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0802051005010.11705@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0802050923220.14675@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Pekka J Enberg wrote:

> Hi Christoph,
> 
> On Mon, 4 Feb 2008, Christoph Lameter wrote:
> > The statistics provided here allow the monitoring of allocator behavior
> > at the cost of some (minimal) loss of performance. Counters are placed in
> > SLUB's per cpu data structure that is already written to by other code.
> 
> Looks good but I am wondering if we want to make the statistics per-CPU so 
> that we can see the kmalloc/kfree ping-pong of, for example, hackbench 

We could do that.... Any idea how to display that kind of information 
in a meaningful way. Parameter conventions for slabinfo?

