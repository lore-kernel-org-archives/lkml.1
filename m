Return-Path: <linux-kernel-owner+w=401wt.eu-S1765631AbXGKRYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765631AbXGKRYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXGKRYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:24:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756734AbXGKRYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:24:32 -0400
Date: Wed, 11 Jul 2007 10:23:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: buffered write patches, -mm merge plans for 2.6.23
Message-Id: <20070711102332.d5ffd572.akpm@linux-foundation.org>
In-Reply-To: <20070711113944.GC18665@lst.de>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070711113944.GC18665@lst.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 13:39:44 +0200 Christoph Hellwig <hch@lst.de> wrote:

> >  pagefault-in-write deadlock fixes.  Will hold for 2.6.24.
> 
> Why that?

At Nick's request.  More work is needed and the code hasn't had a lot of
testing/thought/exposure/review.

>  This stuff has been in forever and is needed at various
> levels.  We need this in for anything to move forward on the buffered
> write front.
