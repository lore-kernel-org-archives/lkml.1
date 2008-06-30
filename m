Return-Path: <linux-kernel-owner+w=401wt.eu-S1751344AbYF3TYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbYF3TYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYF3TYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:24:12 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58850 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYF3TYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:24:11 -0400
Date: Mon, 30 Jun 2008 20:23:54 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splitlru: BDI_CAP_SWAP_BACKED
In-Reply-To: <20080630115354.3a75edd3.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0806302020260.27080@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
 <Pine.LNX.4.64.0806290122330.21758@blonde.site> <20080629173841.37CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20080630115354.3a75edd3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, KAMEZAWA Hiroyuki wrote:
> 
> Hmm, how about adding LRU only for shmem/tmpfs ? nonsense ? ;)

I'd much prefer not: the more LRUs, the more balancing problems;
And I don't think shmem/tmpfs _deserves_ its own LRUs.
But it cannot be ruled out.

Hugh
