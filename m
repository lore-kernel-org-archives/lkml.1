Return-Path: <linux-kernel-owner+w=401wt.eu-S1760449AbYHBT44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449AbYHBT44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbYHBT4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:56:47 -0400
Received: from 1wt.eu ([62.212.114.60]:2368 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690AbYHBT4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:56:46 -0400
Date: Sat, 2 Aug 2008 21:56:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC, 2.6.26.2-rc1] exec: remove some includes
Message-ID: <20080802195622.GG615@1wt.eu>
References: <200808022145.17161.oliver.pntr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808022145.17161.oliver.pntr@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 09:45:17PM +0200, Oliver Pinter wrote:
> >From ba92a43dbaee339cf5915ef766d3d3ffbaaf103c Mon Sep 17 00:00:00 2001
> From: Hugh Dickins <hugh@veritas.com>
> Date: Fri, 25 Jul 2008 01:45:43 -0700
> Subject: [PATCH] exec: remove some includes
> 
> [ Upstream commit ba92a43dbaee339cf5915ef766d3d3ffbaaf103c ]
> 
> fs/exec.c used to need mman.h pagemap.h swap.h and rmap.h when it did
> mm-ish stuff in install_arg_page(); but no need for them after 2.6.22.
                                          ^^^^^^^
Oliver, this patch apparently fixes nothing, and playing with includes
always causes a risk of regression. Please ensure that only fixes for
real problems are submitted to stable and check stable_kernel_rules.txt
when in doubt.

Willy

