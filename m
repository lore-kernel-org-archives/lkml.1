Return-Path: <linux-kernel-owner+w=401wt.eu-S1760559AbXEUMwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559AbXEUMwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbXEUMwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:52:32 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41063 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbXEUMwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:52:31 -0400
Date: Mon, 21 May 2007 13:52:08 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: clameter@sgi.com
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com
Subject: Re: [patch 00/10] Slab defragmentation V2
In-Reply-To: <20070518181040.465335396@sgi.com>
Message-ID: <Pine.LNX.4.64.0705211349090.28830@blonde.wat.veritas.com>
References: <20070518181040.465335396@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 21 May 2007 12:52:30.0811 (UTC) FILETIME=[E4C17AB0:01C79BA6]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBjbGFtZXRlckBzZ2kuY29tAGRnY0BzZ2kuY29tAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, clameter@sgi.com wrote:
> Hugh: Could you have a look at this? There is lots of critical locking
> here....

Sorry, Christoph, no: I've far too many bugs to chase, and unfulfilled
promises outstanding: this is not something I can spend time on - sorry.

Hugh

> Support for Slab defragmentation and targeted reclaim. The current
> state of affairs is that a large portion of inode and dcache slab caches
> can be effectively reclaimed. The remaining problems are:
