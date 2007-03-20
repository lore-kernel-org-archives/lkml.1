Return-Path: <linux-kernel-owner+w=401wt.eu-S965695AbXCTSmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965695AbXCTSmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965896AbXCTSlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:41:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60938 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965686AbXCTSlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:41:39 -0400
Date: Tue, 20 Mar 2007 11:41:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
In-Reply-To: <84144f020703200006q5fbd7835y216426e77e48cc71@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703201140350.8561@schroedinger.engr.sgi.com>
References: <20070319141038.212d4ac9.akpm@linux-foundation.org> 
 <az5Ytbv5.1174339536.7416370.penberg@cs.helsinki.fi> 
 <20070319144100.8a87f288.akpm@linux-foundation.org>
 <84144f020703200006q5fbd7835y216426e77e48cc71@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Pekka Enberg wrote:

> On 3/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > The BUG_ON (at least) should probably be moved into CONFIG_DEBUG_SLAB.
> 
> No it shouldn't. Letting non-slab pages pass through causes nasty and
> hard to debug problems which is why we have the BUG_ONs in the first
> place:

CONFIG_DEBUG_SLAB is there in order to handle these nasty and hard to 
debug problems. Usually non-slab pages are not passed to kmem_cache_free.

