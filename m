Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXDKFuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXDKFuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 01:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030484AbXDKFuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 01:50:01 -0400
Received: from ozlabs.org ([203.10.76.45]:36576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478AbXDKFuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 01:50:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17948.29982.857777.776522@cargo.ozlabs.ibm.com>
Date: Wed, 11 Apr 2007 15:41:50 +1000
From: Paul Mackerras <paulus@samba.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [QUICKLIST 1/4] Quicklists for page table pages V5
In-Reply-To: <1176265121.8061.66.camel@localhost.localdomain>
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
	<1176180337.8061.21.camel@localhost.localdomain>
	<Pine.LNX.4.64.0704102058420.18321@schroedinger.engr.sgi.com>
	<1176265121.8061.66.camel@localhost.localdomain>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:

> > > For a 64K page size kernel, we have 3 level page tables and we use 3
> > > caches: a PGD pages are 128 bytes (yeah, not big heh...), our pmd
> > > pages are 32K (half a page) and PTE pages are PAGE_SIZE (64K).
> > 
> > Ok so use quicklists for the PTEs and slab for the rest? A PGD of only 128 
> > bytes? Stuff one at the end of the mm_struct or the task struct? That way 
> > you can avoid allocation overhead.
> 
> Yeah, maybe... I need to think about it a bit more. I might be able to
> make the PMD a full page too.

There was a reason for making the PMD level map 256MB.  I'd have to
remember what that was and make sure it didn't apply any more first...

Paul.
