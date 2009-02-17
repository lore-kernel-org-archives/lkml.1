Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015AbZBQQ2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbZBQQ2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZBQQ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:28:29 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:50275 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751301AbZBQQ23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:28:29 -0500
Date: Tue, 17 Feb 2009 11:20:40 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
In-Reply-To: <4999BBE6.2080003@cs.helsinki.fi>
Message-ID: <alpine.DEB.1.10.0902171120040.27813@qirst.com>
References: <20090123154653.GA14517@wotan.suse.de> <200902041748.41801.nickpiggin@yahoo.com.au> <20090204152709.GA4799@csn.ul.ie> <200902051459.30064.nickpiggin@yahoo.com.au> <20090216184200.GA31264@csn.ul.ie> <4999BBE6.2080003@cs.helsinki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009, Pekka Enberg wrote:

> Btw, Yanmin, do you have access to the tests Mel is running (especially the
> ones where slub-rvrt seems to do worse)? Can you see this kind of regression?
> The results make we wonder whether we should avoid reverting all of the page
> allocator pass-through and just add a kmalloc cache for 8K allocations. Or not
> address the netperf regression at all. Double-hmm.


Going to 8k for the limit beyond we pass through to the page allocator may
be the simplest and best solution. Someone please work on the page
allocator...

