Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbXJ1NIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbXJ1NIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 09:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXJ1NII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 09:08:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59419 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXJ1NIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 09:08:07 -0400
Date: Sun, 28 Oct 2007 15:08:06 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/10] SLUB: Noinline some functions to avoid them being
 folded into alloc/free
In-Reply-To: <20071028033258.779134394@sgi.com>
Message-ID: <Pine.LNX.4.64.0710281507500.6766@sbz-30.cs.Helsinki.FI>
References: <20071028033156.022983073@sgi.com> <20071028033258.779134394@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Christoph Lameter wrote:
> Some function tend to get folded into __slab_free and __slab_alloc
> although they are rarely called. They cause register pressure that
> leads to bad code generation.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
