Return-Path: <linux-kernel-owner+w=401wt.eu-S936045AbYBWIQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936045AbYBWIQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765403AbYBWII7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:08:59 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933044AbYBWIIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:53 -0500
Date: Sat, 23 Feb 2008 00:05:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 07/28] mm: emergency pool
Message-Id: <20080223000554.04c4f755.akpm@linux-foundation.org>
In-Reply-To: <20080220150306.165236000@chello.nl>
References: <20080220144610.548202000@chello.nl>
	<20080220150306.165236000@chello.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 15:46:17 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> @@ -213,7 +213,7 @@ enum zone_type {
>  
>  struct zone {
>  	/* Fields commonly accessed by the page allocator */
> -	unsigned long		pages_min, pages_low, pages_high;
> +	unsigned long		pages_emerg, pages_min, pages_low, pages_high;

It would be nice to make these one-per-line, then document them.
