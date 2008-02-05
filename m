Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbYBEV6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbYBEV6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbYBEV6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:58:09 -0500
Received: from relay2.sgi.com ([192.48.171.30]:34475 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756707AbYBEV6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:58:07 -0500
Date: Tue, 5 Feb 2008 13:58:06 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: SLUB: Support for statistics to help analyze allocator behavior
In-Reply-To: <47A8C508.6010305@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0802051355270.14665@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0802050923220.14675@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0802051005010.11705@schroedinger.engr.sgi.com>
 <47A8C508.6010305@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Pekka Enberg wrote:

> > We could do that.... Any idea how to display that kind of information in a
> > meaningful way. Parameter conventions for slabinfo?
> 
> We could just print out one total summary and one summary for each CPU (and
> maybe show % of total allocations/fees. That way you can immediately spot if
> some CPUs are doing more allocations/freeing than others.

Ok that would work for small amounts of cpus. Note that we are moving 
to quad core, many standard enterprise servers already have 8 and will 
likely have 16 next year. Our machine can have thousands of processors 
(new "practical" limit is 4k cpus although we could reach 16k cpus 
easily). I was a bit scared to open that can of worms.

