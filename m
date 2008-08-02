Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbYHBTx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbYHBTx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbYHBTxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:53:48 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42198 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbYHBTxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:53:48 -0400
Date: Sat, 2 Aug 2008 20:53:32 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Oliver Pinter <oliver.pntr@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC, 2.6.26.2-rc1] exec: remove some includes
In-Reply-To: <alpine.LFD.1.10.0808021239040.3874@nehalem.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0808022046310.20316@blonde.site>
References: <200808022145.17161.oliver.pntr@gmail.com>
 <alpine.LFD.1.10.0808021239040.3874@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2008, Linus Torvalds wrote:
> On Sat, 2 Aug 2008, Oliver Pinter wrote:
> > 
> > [ Upstream commit ba92a43dbaee339cf5915ef766d3d3ffbaaf103c ]
> > 
> > fs/exec.c used to need mman.h pagemap.h swap.h and rmap.h when it did
> > mm-ish stuff in install_arg_page(); but no need for them after 2.6.22.
> 
> Why on earth would this be -stable material?

Of course it isn't -stable material, I don't know what Oliver's on.

Maybe he noticed akpm's "unbreak arm" comment and thought it was
fixing some pre-existing breakage: no, akpm restored swap.h to
fix the arm build.  Then after this commit, we had to restore
pagemap.h to fix avr32 and !CONFIG_SWAP builds.

Prime material for -unstable, I'm ashamed to say.

Hugh
