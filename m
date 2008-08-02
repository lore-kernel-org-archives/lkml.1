Return-Path: <linux-kernel-owner+w=401wt.eu-S1762529AbYHBTlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762529AbYHBTlW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762032AbYHBTkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:40:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761862AbYHBTkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:40:31 -0400
Date: Sat, 2 Aug 2008 12:39:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: Hugh Dickins <hugh@veritas.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC, 2.6.26.2-rc1] exec: remove some includes
In-Reply-To: <200808022145.17161.oliver.pntr@gmail.com>
Message-ID: <alpine.LFD.1.10.0808021239040.3874@nehalem.linux-foundation.org>
References: <200808022145.17161.oliver.pntr@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Aug 2008, Oliver Pinter wrote:
> 
> [ Upstream commit ba92a43dbaee339cf5915ef766d3d3ffbaaf103c ]
> 
> fs/exec.c used to need mman.h pagemap.h swap.h and rmap.h when it did
> mm-ish stuff in install_arg_page(); but no need for them after 2.6.22.

Why on earth would this be -stable material?

		Linus
