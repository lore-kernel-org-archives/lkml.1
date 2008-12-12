Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbYLLQBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbYLLQBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbYLLQBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:01:40 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:40730 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbYLLQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:01:39 -0500
Date: Fri, 12 Dec 2008 16:01:50 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Rik van Riel <riel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Jean Delvare <khali@linux-fr.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
In-Reply-To: <2f11576a0812120711l130e07c3x94ff3b1e64959edf@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812121559220.19722@blonde.anvils>
References: <20081211202923.330F.KOSAKI.MOTOHIRO@jp.fujitsu.com> 
 <20081211113646.GI23742@kernel.dk>  <20081211204006.3312.KOSAKI.MOTOHIRO@jp.fujitsu.com>
  <20081212075844.GH23742@kernel.dk> <49426C16.6040108@redhat.com>
 <2f11576a0812120711l130e07c3x94ff3b1e64959edf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008, KOSAKI Motohiro wrote:
> >> Me neither, lets ask the originator of the patch. Rik, why is
> >> unevictable lru an option?
> >
> > I think we had some reasons to keep it as a separate config
> > option during development, but nowadays we might as well
> > put it all just under CONFIG_SWAP...
> 
> I'm sad ;)
> 
> To move mlocked file cache page to unevictable list is useful although
> swapless embedded device.

Yes, I don't understand why Rik suggested CONFIG_SWAP for it either.

> 
> Actually, number of scanning pages of reclaim is calculated by number
> of pages in list.
> if unevictable page stay in evictable list a lot, reclaim logic can
> calculate wrong scanning number.
