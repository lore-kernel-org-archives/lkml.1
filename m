Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbZGJXvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbZGJXvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 19:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbZGJXvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 19:51:25 -0400
Received: from mail2.shareable.org ([80.68.89.115]:50096 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbZGJXvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 19:51:25 -0400
Date: Sat, 11 Jul 2009 00:51:23 +0100
From: Jamie Lokier <jamie@shareable.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>
Subject: Re: [PATCH] ARM: copy_page.S: take into account the size of the cache line
Message-ID: <20090710235123.GE30322@shareable.org>
References: <1247156605-16245-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247156605-16245-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> From: Kirill A. Shutemov <kirill@shutemov.name>
> 
> Optimized version of copy_page() was written with assumption that cache
> line size is 32 bytes. On Cortex-A8 cache line size is 64 bytes.
> 
> This patch tries to generalize copy_page() to work with any cache line
> size if cache line size is multiple of 16 and page size is multiple of
> two cache line size.
> 
> Unfortunately, kernel doesn't provide a macros with correct cache size.
> L1_CACHE_SHIFT is 5 on any ARM. So we have to define macros for this
> propose by ourself.

Why don't you fix L1_CACHE_SHIFT for Cortex-A8?

-- Jamie
