Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbXCKDWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbXCKDWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 22:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932806AbXCKDWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 22:22:16 -0500
Received: from holomorphy.com ([66.93.40.71]:57370 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801AbXCKDWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 22:22:15 -0500
Date: Sat, 10 Mar 2007 19:22:13 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.com, linux-ia64@vger.kernel.org,
       holt@sgi.com, mpm@selenic.com
Subject: Re: [QUICKLIST 2/6] i386: quicklist support
Message-ID: <20070311032213.GJ2986@holomorphy.com>
References: <20070311020923.19905.49260.sendpatchset@schroedinger.engr.sgi.com> <20070311020934.19905.57850.sendpatchset@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311020934.19905.57850.sendpatchset@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 06:09:34PM -0800, Christoph Lameter wrote:
> i386: Convert to quicklists
> Implement the i386 management of pgd and pmds using quicklists.

I approve, though it would be nice if ptes had an interface operating
on struct page * to use.


On Sat, Mar 10, 2007 at 06:09:34PM -0800, Christoph Lameter wrote:
> The i386 management of page table pages currently uses page sized slabs.
> The page state is therefore mainly determined by the slab code. However,
> i386 also uses its own fields in the page struct to mark special pages
> and to build a list of pgds using the ->private and ->index field (yuck!).
> This has been finely tuned to work right with SLAB but SLUB needs more
> control over the page struct. Currently the only way for SLUB to support
> these slabs is through special casing PAGE_SIZE slabs.
> If we use quicklists instead then we can avoid the mess, and also the
> overhead of manipulating page sized objects through slab.

Hey! I did quite well given the constraints under which I was operating.


-- wli
