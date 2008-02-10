Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYBJAWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYBJAWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 19:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYBJAVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 19:21:55 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41598 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756156AbYBJAVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 19:21:54 -0500
Date: Sat, 9 Feb 2008 16:21:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: mm/slub.c warnings
In-Reply-To: <19f34abd0802090913w64773c44qb44a1d338cc10b4f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802091620440.13328@schroedinger.engr.sgi.com>
References: <19f34abd0802090913w64773c44qb44a1d338cc10b4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Vegard Nossum wrote:

> Hi,
> 
> I get these warnings when compiling mm/slub.c in linux-2.6.git:
> 
> mm/slub.c: In function 'slab_alloc':
> mm/slub.c:1637: warning: assignment makes pointer from integer without a cast
> mm/slub.c:1637: warning: assignment makes pointer from integer without a cast
> mm/slub.c: In function 'slab_free':
> mm/slub.c:1796: warning: assignment makes pointer from integer without a cast
> mm/slub.c:1796: warning: assignment makes pointer from integer without a cast
> 
> The actual lines are calls to cmpxchg_local(). This is probably
> because I'm compiling with M386. I'm guessing the source of the
> warnings is in include/asm-x86/cmpxchg_32.h, lines 283 and 286. Config
> attached.

Hmmm.. That cmpxchg local needs to be fixed? Mathieu?


