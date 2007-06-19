Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbXFSWd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbXFSWd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760127AbXFSWdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:33:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54658 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757740AbXFSWdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:33:09 -0400
Date: Tue, 19 Jun 2007 15:33:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       suresh.b.siddha@intel.com
Subject: Re: [patch 05/26] Slab allocators: Cleanup zeroing allocations
In-Reply-To: <20070619210010.GN11166@waste.org>
Message-ID: <Pine.LNX.4.64.0706191532170.7633@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com> <20070618095914.622685354@sgi.com>
 <20070619210010.GN11166@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Matt Mackall wrote:

> I worry a bit about adding another branch checking __GFP_ZERO in such
> a hot path for SLAB/SLUB.

Its checking the gfpflags variable on the stack. In a recently touched 
cachline.


