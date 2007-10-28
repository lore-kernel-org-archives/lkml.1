Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbXJ1NKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbXJ1NKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 09:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbXJ1NKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 09:10:06 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44710 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXJ1NKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 09:10:05 -0400
Date: Sun, 28 Oct 2007 15:10:03 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 04/10] SLUB: Avoid checking for a valid object before
 zeroing on the fast path
In-Reply-To: <20071028033259.263401839@sgi.com>
Message-ID: <Pine.LNX.4.64.0710281509510.6766@sbz-30.cs.Helsinki.FI>
References: <20071028033156.022983073@sgi.com> <20071028033259.263401839@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Christoph Lameter wrote:
> The fast path always results in a valid object. Move the check
> for the NULL pointer to the slow branch that calls
> __slab_alloc. Only __slab_alloc can return NULL if there is no
> memory available anymore and that case is exceedingly rare.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
