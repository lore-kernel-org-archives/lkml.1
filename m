Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYHAMLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYHAMLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYHAMLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:11:40 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48444 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbYHAMLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:11:40 -0400
Date: Fri, 1 Aug 2008 13:11:09 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jack Steiner <steiner@sgi.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Robin Holt <holt@sgi.com>,
       "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: GRU driver feedback
In-Reply-To: <20080731124039.GA27329@sgi.com>
Message-ID: <Pine.LNX.4.64.0808011305080.20052@blonde.site>
References: <20080723141229.GB13247@wotan.suse.de> <20080729185315.GA14260@sgi.com>
 <200807301550.34500.nickpiggin@yahoo.com.au> <200807311714.05252.nickpiggin@yahoo.com.au>
 <20080731124039.GA27329@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Jack Steiner wrote:
> 
> I'm collecting the fixes & additional comments to be added & will send
> them upstream later.

One small thing to remove if you've not already noticed:
EXPORT_SYMBOL_GPL(follow_page) got added to mm/memory.c,
despite our realization that GRU cannot and now does not use it.

Hugh
