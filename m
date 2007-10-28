Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbXJ1POV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbXJ1POV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbXJ1POO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:14:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56907 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbXJ1PON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:14:13 -0400
Date: Sun, 28 Oct 2007 17:14:12 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 09/10] SLUB: Do our own locking via slab_lock and
 slab_unlock.
In-Reply-To: <Pine.LNX.4.64.0710281702140.6766@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0710281713020.6766@sbz-30.cs.Helsinki.FI>
References: <20071028033156.022983073@sgi.com> <20071028033300.479692380@sgi.com>
 <Pine.LNX.4.64.0710281702140.6766@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Pekka J Enberg wrote:
> > +	 __release(bitlock);
> 
> This needs a less generic name and maybe a comment explaining that it's 
> not annotating a proper lock? Or maybe we can drop it completely?

Ah, I see that <linux/bit_spinlock.h> does the same thing, so strike that.
