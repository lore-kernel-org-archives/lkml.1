Return-Path: <linux-kernel-owner+w=401wt.eu-S1766942AbXEBUOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766942AbXEBUOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766946AbXEBUOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:14:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38349 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766942AbXEBUOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:14:11 -0400
Date: Wed, 2 May 2007 13:14:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070502195412.GC9044@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0705021312410.1978@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <20070501133618.93793687.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705021346170.16517@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705021002040.32271@schroedinger.engr.sgi.com>
 <20070502121105.de3433d5.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705021234470.1543@schroedinger.engr.sgi.com>
 <20070502195412.GC9044@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Sam Ravnborg wrote:

> To facilitate this do NOT introduce CONFIG_SLAB until we decide
> that SLUB are default. In this way we can make CONFIG_SLUB be default
> and people will not continue with CONFIG_SLAB because they had it in their
> config already.

We already have CONFIG_SLAB. If you use your existing .config then
you will stay with SLAB.

> The point is make sure that LSUB becomes default for people that does
> an make oldconfig (explicit or implicit).

Hmmmm... We can think about that when we actually want to make SLUB the 
default.

