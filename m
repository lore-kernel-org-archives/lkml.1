Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbXEIQjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbXEIQjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbXEIQjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:39:16 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33359 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbXEIQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:39:15 -0400
Date: Wed, 9 May 2007 17:38:46 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
In-Reply-To: <463B598B.80200@redhat.com>
Message-ID: <Pine.LNX.4.64.0705091724500.25202@blonde.wat.veritas.com>
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au>
 <463B598B.80200@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 09 May 2007 16:39:01.0393 (UTC) FILETIME=[8C6AB810:01C79258]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAdG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBsaW51eC1tbUBrdmFjay5vcmcAZHJlcHBlckByZWRoYXQuY29tAGpha3ViQHJlZGhhdC5jb20AcmllbEByZWRoYXQuY29tAG5pY2twaWdnaW5AeWFob28uY29tLmF1AA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Ulrich Drepper wrote:
> 
> I don't want to judge the numbers since I cannot but I want to make an
> observations: even if in the SMP case MADV_FREE turns out to not be a
> bigger boost then there is still the UP case to keep in mind where Rik
> measured a significant speed-up.  As long as the SMP case isn't hurt
> this is reaosn enough to use the patch.  With more and more cores on one
> processor SMP systems are pushed evermore to the high-end side.  You'll
> find many installations which today use SMP will be happy enough with
> many-core UP machines.

Just remembered this mail from a few days ago, and how puzzled I'd been
by your last sentence or two: I seem to be reading it in the wrong way,
and don't understand why users of SMP kernels will be moving to UP?

UP in the sense of one processor but many cores?  But that still needs
an SMP kernel to use all those cores.  Or you're thinking of growing
virtualization?  Would you please explain further?

Thanks,
Hugh
