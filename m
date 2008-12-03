Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbYLCMxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYLCMxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYLCMwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:52:54 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56127 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYLCMwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:52:54 -0500
Date: Wed, 3 Dec 2008 12:52:53 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: dwmw2@infradead.org, jens.axboe@oracle.com, matthew@wil.cx,
       joern@logfs.org, James.Bottomley@HansenPartnership.com,
       djshin90@gmail.com, teheo@suse.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/9] swapfile: change discard pgoff_t to sector_t
In-Reply-To: <20081202164732.1d6d0997.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0812031251260.6817@blonde.anvils>
References: <Pine.LNX.4.64.0811252132580.17555@blonde.site>
 <Pine.LNX.4.64.0811252140230.17555@blonde.site> <Pine.LNX.4.64.0811252145190.20455@blonde.site>
 <Pine.LNX.4.64.0812010028040.10131@blonde.site> <20081202164732.1d6d0997.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008, Andrew Morton wrote:
> On Mon, 1 Dec 2008 00:29:41 +0000 (GMT)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > -		pgoff_t nr_blocks = se->nr_pages << (PAGE_SHIFT - 9);
> > +		sector_t nr_blocks = se->nr_pages << (PAGE_SHIFT - 9);
> 
> but, but, that didn't change anything?  se->nr_pages must be cast to
> sector_t?

I'm squirming, you are right, thanks for fixing it up.

Hugh
