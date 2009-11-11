Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbZKKX57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbZKKX57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 18:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758691AbZKKX56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 18:57:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757528AbZKKX56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 18:57:58 -0500
Date: Wed, 11 Nov 2009 15:56:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, chrisw@sous-sol.org,
       wmw2@infradead.org, joerg.roedel@amd.com, muli@il.ibm.com,
       hannes@cmpxchg.org, tj@kernel.org
Subject: Re: [PATCH -v2 6/9] bootmem: add free_bootmem_late
Message-Id: <20091111155644.196ce5c7.akpm@linux-foundation.org>
In-Reply-To: <1257849980-22640-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1257849980-22640-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 19:46:17 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Add a new function for freeing bootmem after the bootmem allocator has
> been released and the unreserved pages given to the page allocator.
> This allows us to reserve bootmem and then release it if we later
> discover it was not needed.

OK, but the new function has no callers and curious people will be
wondering what happened to patches 1, 2, 3, 4, 5, 7, 8 and 9!

What's the plan here?
