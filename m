Return-Path: <linux-kernel-owner+w=401wt.eu-S376198AbXECQbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376198AbXECQbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376206AbXECQbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:31:01 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60549 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S376198AbXECQbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:31:00 -0400
Date: Thu, 3 May 2007 09:30:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       haveblue@ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070503082716.GE19966@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0705030928560.8386@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com>
 <20070503011515.0d89082b.akpm@linux-foundation.org> <20070503082716.GE19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, William Lee Irwin III wrote:

> I've seen this crash in flush_old_exec() before. ISTR it being due to
> slub vs. pagetable alignment or something on that order.

>From from other discussion regarding SLAB: It may be necessary for 
powerpc to set the default alignment to 8 bytes on 32 bit powerpc 
because it requires that alignemnt for 64 bit value. SLUB will *not* 
disable debugging like SLAB if you do that.
