Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbXFVBmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbXFVBmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 21:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXFVBly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 21:41:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33699 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751290AbXFVBly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 21:41:54 -0400
Date: Thu, 21 Jun 2007 18:41:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706211839440.11717@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Hugh Dickins wrote:

> Seems a little odd that it's gone throughout 2.6.22-rc unnoticed
> until now - nobody else trying SLUB on ARM or PA-RISC yet perhaps.

The impact is only on a subset of ARM machines.

PA_RISC? It looks like they run their own flushing function for byte 
ranges called flush_kernel_dache_range. That does not use the page struct.


