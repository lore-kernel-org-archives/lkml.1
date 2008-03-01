Return-Path: <linux-kernel-owner+w=401wt.eu-S1763605AbYCAQaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763605AbYCAQaH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763479AbYCAQ0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:26:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763469AbYCAQ0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:26:34 -0500
Date: Sat, 1 Mar 2008 11:26:00 -0500
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, apw@shadowen.org,
       linux-mm@kback.org
Subject: Re: [rfc 07/10] Pageflags: Get rid of FLAGS_RESERVED
Message-ID: <20080301112600.4e01c3a2@bree.surriel.com>
In-Reply-To: <20080301040621.484085808@sgi.com>
References: <20080301040534.797979115@sgi.com>
	<20080301040621.484085808@sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 20:05:41 -0800
Christoph Lameter <clameter@sgi.com> wrote:

> Index: linux-2.6/include/linux/bounds.h
> ===================================================================
> --- linux-2.6.orig/include/linux/bounds.h	2008-02-29 19:30:04.000000000 -0800
> +++ linux-2.6/include/linux/bounds.h	2008-02-29 19:30:08.000000000 -0800
> @@ -7,4 +7,6 @@
>   *
>   */
>  
> +#define NR_PAGEFLAGS 32 /* __NR_PAGEFLAGS	# */
> +
>  #endif

Did part of your automatically generated file just leak into the patch
series?

-- 
All rights reversed.
