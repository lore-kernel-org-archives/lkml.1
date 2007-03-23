Return-Path: <linux-kernel-owner+w=401wt.eu-S1422655AbXCWGwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422655AbXCWGwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422652AbXCWGwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:52:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33713 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933820AbXCWGwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:52:05 -0400
Date: Thu, 22 Mar 2007 23:52:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V4
In-Reply-To: <20070322223927.bb4caf43.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703222339560.19630@schroedinger.engr.sgi.com>
References: <20070323062843.19502.19827.sendpatchset@schroedinger.engr.sgi.com>
 <20070322223927.bb4caf43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007, Andrew Morton wrote:

> On Thu, 22 Mar 2007 23:28:41 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> 
> > 1. Proven code from the IA64 arch.
> > 
> > 	The method used here has been fine tuned for years and
> > 	is NUMA aware. It is based on the knowledge that accesses
> > 	to page table pages are sparse in nature. Taking a page
> > 	off the freelists instead of allocating a zeroed pages
> > 	allows a reduction of number of cachelines touched
> > 	in addition to getting rid of the slab overhead. So
> > 	performance improves.
> 
> By how much?

About 40% on fork+exit. See 

http://marc.info/?l=linux-ia64&m=110942798406005&w=2

 
