Return-Path: <linux-kernel-owner+w=401wt.eu-S1760649AbXFVTLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbXFVTLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759839AbXFVTLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:11:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56371 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756483AbXFVTLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:11:35 -0400
Date: Fri, 22 Jun 2007 12:11:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706221955360.9081@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706221206130.18210@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706221143190.17958@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221955360.9081@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Hugh Dickins wrote:

> Acked-by: Hugh Dickins <hugh@veritas.com>
> (immediately after 2.6.22, accompanied by your ARM patch)

We need to fix any remaining weird slab object uses right now. Your check 
leaves a lot of holes open. 2.6.22 removes all other such strange slab 
uses in other arches. It would be inconsistent if we left these things in 
ARM (and maybe PA-RISC).





