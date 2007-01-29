Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbXA2TTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbXA2TTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXA2TTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:19:18 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:5553 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXA2TTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:19:17 -0500
X-AuditID: d80ac287-9e4e8bb000007e48-3b-45be4ade25bc 
Date: Mon, 29 Jan 2007 19:19:24 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@osdl.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
In-Reply-To: <20070129190806.GA14353@elte.hu>
Message-ID: <Pine.LNX.4.64.0701291916420.10401@blonde.wat.veritas.com>
References: <1169993494.10987.23.camel@lappy> <20070128142925.df2f4dce.akpm@osdl.org>
 <20070129190806.GA14353@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 29 Jan 2007 19:19:16.0025 (UTC) FILETIME=[5DE02290:01C743DA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Ingo Molnar wrote:
> 
> For every 64-bit Fedora box there's more than seven 32-bit boxes. I 
> think 32-bit is going to live with us far longer than many thought, so 
> we might as well make it work better. Both HIGHMEM and HIGHPTE is the 
> default on many distro kernels, which pushes the kmap infrastructure 
> quite a bit.

But HIGHPTE uses kmap_atomic (in mainline: does -rt use kmap there?)

Hugh
