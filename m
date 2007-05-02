Return-Path: <linux-kernel-owner+w=401wt.eu-S1767175AbXEBSjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767175AbXEBSjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767177AbXEBSjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:39:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32943 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767175AbXEBSjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:39:20 -0400
Date: Wed, 2 May 2007 11:39:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, haveblue@ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <Pine.LNX.4.64.0705021924200.24456@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0705021137210.1027@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021924200.24456@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Hugh Dickins wrote:

> I'm astonished and impressed, both with Kconfig and your use of it:

Thanks!

> I'd much rather be testing a quicklist patch:
> I'd better give that a try.

Great. But I certainly do not mind people use SLAB. I do not think that 
one approach should be there for all. Choice is the way to have multiple 
allocators compete. One reason that SLAB is so crusty is because it was 
the only solution for so long.


