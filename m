Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbXFVFNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbXFVFNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXFVFNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:13:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58068 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751279AbXFVFNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:13:04 -0400
Date: Thu, 21 Jun 2007 22:13:03 -0700 (PDT)
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
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706220513140.8870@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706212211010.12278@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211759550.11554@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220513140.8870@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Hugh Dickins wrote:

> You keep on forcing the outside world to revolve around your needs
> within slub.c: that is a good way to keep slub lean, and may be
> justified; but it's at least questionable to be enforcing such
> restrictions years after people have grown accustomed to more
> freedom from their slabs.

This work is a cleanup of the VM code and part of the slab cleanup that 
was done. Having slab objects on the LRU and other components of the VM 
that are supposed to work on page sized objects is plainly wrong and can 
lead to surprising results.


