Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbXJ1NHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbXJ1NHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 09:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXJ1NHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 09:07:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59419 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXJ1NHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 09:07:44 -0400
Date: Sun, 28 Oct 2007 15:07:43 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 01/10] SLUB: Consolidate add_partial and add_partial_tail
 to one function
In-Reply-To: <20071028033258.546533164@sgi.com>
Message-ID: <Pine.LNX.4.64.0710281506400.6766@sbz-30.cs.Helsinki.FI>
References: <20071028033156.022983073@sgi.com> <20071028033258.546533164@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Christoph Lameter wrote:
> Add a parameter to add_partial instead of having separate functions.
> That allows the detailed control from multiple places when putting
> slabs back to the partial list. If we put slabs back to the front
> then they are likely immediately used for allocations. If they are
> put at the end then we can maximize the time that the partial slabs
> spent without allocations.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
