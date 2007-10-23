Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbXJWT51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbXJWT51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbXJWT5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:57:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59161 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752570AbXJWT5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:57:16 -0400
Date: Tue, 23 Oct 2007 12:57:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, mel@skynet.ie
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
In-Reply-To: <471E5021.8090300@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0710231250130.19904@schroedinger.engr.sgi.com>
References: <20071023181615.GA10377@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com>
 <471E5021.8090300@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Pekka Enberg wrote:

> > > cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
> 
> Christoph Lameter wrote:
> > Regular Order 0 alloc .... but why is there no memory available , reclaimed?
> 
> I am too wondering where all that memory is going. Logging /proc/meminfo and
> slabinfo -S (see Documentation/vm/slabinfo.c) every few minutes or so probably
> might help answering that question

__GFP_HARDWALL and __GFP_MOVABLE is set. I guess we have no cpusets on the 
box? Wonder what the antifrag status is? Can we get /proc/pagetypeinfo?


