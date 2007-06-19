Return-Path: <linux-kernel-owner+w=401wt.eu-S933346AbXFSUJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346AbXFSUJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760777AbXFSUJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:09:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36561 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762262AbXFSUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:09:27 -0400
Date: Tue, 19 Jun 2007 13:08:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, suresh.b.siddha@intel.com
Subject: Re: [patch 10/26] SLUB: Faster more efficient slab determination
 for __kmalloc.
Message-Id: <20070619130858.693ae66e.akpm@linux-foundation.org>
In-Reply-To: <20070618095915.826976488@sgi.com>
References: <20070618095838.238615343@sgi.com>
	<20070618095915.826976488@sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 02:58:48 -0700
clameter@sgi.com wrote:

> +	BUG_ON(KMALLOC_MIN_SIZE > 256 ||
> +		(KMALLOC_MIN_SIZE & (KMALLOC_MIN_SIZE - 1)));

BUILD_BUG_ON?
