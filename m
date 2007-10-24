Return-Path: <linux-kernel-owner+w=401wt.eu-S1765833AbXJXRCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765833AbXJXRCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764241AbXJXQ4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:56:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57300 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764213AbXJXQ4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:56:43 -0400
Date: Wed, 24 Oct 2007 09:56:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       Linux MM <linux-mm@kvack.org>
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
In-Reply-To: <84144f020710231341p189435b1y5514e5be981b9b1c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710240955480.26202@schroedinger.engr.sgi.com>
References: <20071023181615.GA10377@martell.zuzino.mipt.ru> 
 <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com> 
 <84144f020710231304h6cba8626na4ab4bec0acda7a0@mail.gmail.com> 
 <Pine.LNX.4.64.0710231305050.20095@schroedinger.engr.sgi.com>
 <84144f020710231341p189435b1y5514e5be981b9b1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Pekka Enberg wrote:

> Yeah, but we're _not failing_ when debugging is enabled. Thus, it's
> likely, that the _failing_ (non-debug) case has potential for more
> order 0 allocs, no? I am just guessing here but maybe it's
> slab_order() behaving differently from calculate_slab_order() so that
> we see more order 0 pressure in SLUB than SLAB?

Seesm that order 0 pressure is better than order 1?


