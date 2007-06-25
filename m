Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbXFYSu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbXFYSu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXFYSuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:50:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42212 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753212AbXFYSup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:50:45 -0400
Date: Mon, 25 Jun 2007 11:50:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706251933540.13382@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706251147400.9332@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
 <20070624083849.GA19079@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0706241122030.27778@blonde.wat.veritas.com>
 <20070624105152.GB14099@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0706250120560.28286@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706250607260.5191@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251729250.4911@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706250952490.8320@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251804420.7592@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706251108180.8907@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251933540.13382@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Hugh Dickins wrote:

> > The "sometimes we have kmalloced buffers" locations need to be fixed.
> 
> I've said enough, I'd better leave it to others to deter you or not
> from fiddling around pointlessly here.

Are there any locations left after the two fixes to pa-risc and arm?

If the ARM fix solves the issue then we may not need that special casing 
anymore. Maybe the sometimes has become never?



