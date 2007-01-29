Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbXA2UQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbXA2UQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbXA2UQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:16:01 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:43333 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752018AbXA2UQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:16:00 -0500
Date: Mon, 29 Jan 2007 12:15:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Jeff Dike <jdike@addtoit.com>
cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab.c ifdef reduction breaks build
In-Reply-To: <20070129200517.GA6229@ccure.user-mode-linux.org>
Message-ID: <Pine.LNX.4.64.0701291214060.32740@schroedinger.engr.sgi.com>
References: <20070129200517.GA6229@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Jeff Dike wrote:

> +#if CONFIG_ZONE_DMA_FLAG
> +		sizes->cs_dmacachep = kmem_cache_create(

This would need to be

#idef CONFIG_ZONE_DMA

There have been some recent changes though so I am not sure what your 
codebase is.

