Return-Path: <linux-kernel-owner+w=401wt.eu-S1760462AbYG1RLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462AbYG1RLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759395AbYG1RLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:11:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760155AbYG1RLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:11:08 -0400
Date: Mon, 28 Jul 2008 12:53:40 -0400
From: Rik van Riel <riel@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] eCryptfs - use page_alloc not kmalloc to get a page of
 memory
Message-ID: <20080728125340.51b0b486@cuia.bos.redhat.com>
In-Reply-To: <488DF00F.3080809@redhat.com>
References: <488DF00F.3080809@redhat.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 11:13:03 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> With SLUB debugging turned on in 2.6.26, I was getting memory corruption
> when testing eCryptfs.  The root cause turned out to be that eCryptfs
> was doing kmalloc(PAGE_CACHE_SIZE); virt_to_page() and treating that
> as a nice page-aligned chunk of memory. 

uh oh

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All Rights Reversed
