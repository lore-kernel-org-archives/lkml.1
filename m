Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbXJ1NJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbXJ1NJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 09:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXJ1NJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 09:09:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44710 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXJ1NJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 09:09:38 -0400
Date: Sun, 28 Oct 2007 15:09:37 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 03/10] SLUB: Move kmem_cache_node determination into
 add_full and add_partial
In-Reply-To: <20071028033259.021882647@sgi.com>
Message-ID: <Pine.LNX.4.64.0710281509110.6766@sbz-30.cs.Helsinki.FI>
References: <20071028033156.022983073@sgi.com> <20071028033259.021882647@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Christoph Lameter wrote:
> The kmem_cache_node determination can be moved into add_full()
> and add_partial(). This removes some code from the slab_free()
> slow path and reduces the register overhead that has to be managed
> in the slow path.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
