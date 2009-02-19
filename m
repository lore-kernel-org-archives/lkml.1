Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZBSIlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZBSIlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 03:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZBSIk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 03:40:56 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43569 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZBSIk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 03:40:56 -0500
Subject: Re: [patch] SLQB slab allocator (try 2)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <alpine.DEB.1.10.0902171204070.15929@qirst.com>
References: <20090123154653.GA14517@wotan.suse.de>
	 <200902041748.41801.nickpiggin@yahoo.com.au>
	 <20090204152709.GA4799@csn.ul.ie>
	 <200902051459.30064.nickpiggin@yahoo.com.au>
	 <20090216184200.GA31264@csn.ul.ie> <4999BBE6.2080003@cs.helsinki.fi>
	 <alpine.DEB.1.10.0902171120040.27813@qirst.com>
	 <1234890096.11511.6.camel@penberg-laptop>
	 <alpine.DEB.1.10.0902171204070.15929@qirst.com>
Date: Thu, 19 Feb 2009 10:40:53 +0200
Message-Id: <1235032853.29813.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 12:05 -0500, Christoph Lameter wrote:
> Well yes you missed two locations (kmalloc_caches array has to be
> redimensioned) and I also was writing the same patch...
> 
> Here is mine:
> 
> Subject: SLUB: Do not pass 8k objects through to the page allocator
> 
> Increase the maximum object size in SLUB so that 8k objects are not
> passed through to the page allocator anymore. The network stack uses 8k
> objects for performance critical operations.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

This is merged now with my fixlets:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=8573e12414365585bfd601dc8c093b3efbef8854

