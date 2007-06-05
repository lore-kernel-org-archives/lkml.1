Return-Path: <linux-kernel-owner+w=401wt.eu-S1764915AbXFERXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764915AbXFERXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbXFERXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:23:38 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52246 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752347AbXFERXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:23:37 -0400
Date: Tue, 5 Jun 2007 10:23:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <4664F44C.4040206@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0706051023040.32415@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com>
 <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com>
 <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com>
 <46646747.2080803@cs.helsinki.fi> <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com>
 <20070604155355.bf29a3a8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com>
 <4664F44C.4040206@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Pekka Enberg wrote:

> FWIW, I am happy :-). We should add a comment to kmalloc() that we return
> non-unique pointers for zero-length allocations though.

Would you do that? Could you also add ZERO_SIZE_PTR support to SLAB?
