Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbYENR63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbYENR63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbYENR6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:58:20 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53458 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756334AbYENR6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:58:19 -0400
Date: Wed, 14 May 2008 10:58:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Benny Halevy <bhalevy@panasas.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SLUB: clear c->freelist in __slab_alloc()/load_freelist:/SlabDebug
 path
In-Reply-To: <482B2752.2090600@panasas.com>
Message-ID: <Pine.LNX.4.64.0805141057390.15585@schroedinger.engr.sgi.com>
References: <4828A940.2090604@panasas.com> <84144f020805131140s233090e5v4f77c4853a91f2ec@mail.gmail.com>
 <4829ED5C.6080503@panasas.com> <Pine.LNX.4.64.0805141043200.15374@schroedinger.engr.sgi.com>
 <482B2752.2090600@panasas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Benny Halevy wrote:


> I probably have misunderstood how the slub debugging infrastructure works
> and did not execute the debug path at all.

Ahh.. So for some reason you set PG_error on a slab page which caused it 
to go into the debug path? Doing I/O on slab objects?


