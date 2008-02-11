Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYBKWjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYBKWjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYBKWjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:39:47 -0500
Received: from waste.org ([66.93.16.53]:50309 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbYBKWjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:39:47 -0500
Subject: Re: [PATCH] slob: fix linking for user mode linux
From: Matt Mackall <mpm@selenic.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, clameter@sgi.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802120032160.27876@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0802120032160.27876@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 16:39:29 -0600
Message-Id: <1202769569.12383.49.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 00:32 +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> UML has some header magic that expects a non-inline __kmalloc() function to be
> available. Fixes the following link time errors:
> 
> arch/um/drivers/built-in.o: In function `kmalloc':
> /home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: undefined reference to `__kmalloc'
> /home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: undefined reference to `__kmalloc'
> /home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: undefined reference to `__kmalloc'
> /home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: undefined reference to `__kmalloc'
> /home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: undefined reference to `__kmalloc'
> arch/um/drivers/built-in.o:/home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: more undefined references to `__kmalloc' follow

Can someone explain why the magic is needed (and preferably capture it
in a comment somewhere sensible)? I took a peek at this and have no idea
what's going on. 

-- 
Mathematics is the supreme nostalgia of our time.

