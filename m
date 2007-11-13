Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbXKMElU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbXKMElU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 23:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbXKMElM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 23:41:12 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:40998 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755148AbXKMElM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 23:41:12 -0500
Date: Mon, 12 Nov 2007 20:41:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ray Lee <ray-lk@madrabbit.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>, Andi Kleen <ak@suse.de>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: x86_64: Make sparsemem/vmemmap the default memory model
In-Reply-To: <2c0942db0711122027m5b11502cveded5705c0bc4f64@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711122040380.30724@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711121549370.29178@schroedinger.engr.sgi.com> 
 <200711130059.34346.ak@suse.de>  <Pine.LNX.4.64.0711121615120.29328@schroedinger.engr.sgi.com>
  <200711130149.54852.ak@suse.de>  <Pine.LNX.4.64.0711121940410.30269@schroedinger.engr.sgi.com>
 <2c0942db0711122027m5b11502cveded5705c0bc4f64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007, Ray Lee wrote:

> Discontig obviously needs to die. However, FlatMem is consistently
> faster, averaging about 2.1% better overall for your numbers above. Is
> the page allocator not, erm, a fast path, where that matters?
> 
> Order	Flat	Sparse	% diff
> 0	639	641	0.3

IMHO Order 0 currently matters most and the difference is negligible 
there.

