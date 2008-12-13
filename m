Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYLMCgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYLMCgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 21:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYLMCgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 21:36:32 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:47321 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbYLMCgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 21:36:31 -0500
Date: Fri, 12 Dec 2008 20:36:21 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>, bcrl@kvack.org,
       list-linux-mm@kvack.org
Subject: Re: [rfc][patch] mm: kfree_size
In-Reply-To: <20081212003130.GA24497@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0812122035410.15781@quilx.com>
References: <20081212002518.GH8294@wotan.suse.de> <20081212003130.GA24497@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008, Nick Piggin wrote:

> Allocators which don't care so much could just define kfree_size to kfree.
>
> Thoughts? Any other good candidate callers?

Would be a good idea together with some sort of allocator skeleton. Not
having to carry the size is especially important for alternate kmalloc
array implementations.

