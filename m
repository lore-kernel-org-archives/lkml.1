Return-Path: <linux-kernel-owner+w=401wt.eu-S966331AbXDDMpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966331AbXDDMpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 08:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966333AbXDDMpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 08:45:20 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:42730 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966331AbXDDMpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 08:45:19 -0400
X-AuditID: d80ac287-91f24bb000000c42-90-46139dde5f6c 
Date: Wed, 4 Apr 2007 13:45:06 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Andrea Arcangeli <andrea@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
In-Reply-To: <20070404102407.GA529@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0704041338450.7416@blonde.wat.veritas.com>
References: <20070329075805.GA6852@wotan.suse.de>
 <Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com>
 <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de>
 <Pine.LNX.4.64.0704041023040.17341@blonde.wat.veritas.com>
 <20070404102407.GA529@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 Apr 2007 12:45:12.0202 (UTC) FILETIME=[15E8CEA0:01C776B7]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Nick Piggin wrote:
> 
> No, you have a point, but if we have to ask people to recompile 
> with CONFIG_ZERO_PAGE, then it isn't much harder to ask them to
> apply a patch first.
> 
> But for a potential mainline merge, maybe starting with a CONFIG
> option is a good idea -- defaulting to off, and we could start by
> turning it on just in -rc kernels for a few releases, to get a bit
> more confidence?

I'm confused.  CONFIG_ZERO_PAGE off is where we'd like to end up: how
would turning CONFIG_ZERO_PAGE on in -rc kernels help us to get there?

Hugh
