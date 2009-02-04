Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbZBDPzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbZBDPzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZBDPzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:55:38 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:56380 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751942AbZBDPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:55:37 -0500
Date: Wed, 4 Feb 2009 10:48:29 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
In-Reply-To: <200902032250.55968.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0902041048140.19633@qirst.com>
References: <20090123154653.GA14517@wotan.suse.de> <200902032136.26022.nickpiggin@yahoo.com.au> <20090203112852.GJ9840@csn.ul.ie> <200902032250.55968.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Nick Piggin wrote:

> > Just to clarify on this last point, do you mean slub_max_order=0 to
> > force order-0 allocations in SLUB?
>
> Hmm... I think slub_min_objects=1 should also do basically the same.
> Actually slub_min_object=1 and slub_max_order=1 should get closest I
> think.

slub_max_order=0 would be sufficient.

