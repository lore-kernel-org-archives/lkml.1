Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbYLLSBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbYLLSBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbYLLSA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:00:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59888 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237AbYLLSA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:00:56 -0500
Message-ID: <4942A6C5.1090606@redhat.com>
Date: Fri, 12 Dec 2008 13:00:37 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jean Delvare <khali@linux-fr.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
References: <20081211202923.330F.KOSAKI.MOTOHIRO@jp.fujitsu.com>  <20081211113646.GI23742@kernel.dk>  <20081211204006.3312.KOSAKI.MOTOHIRO@jp.fujitsu.com>  <20081212075844.GH23742@kernel.dk> <49426C16.6040108@redhat.com> <2f11576a0812120711l130e07c3x94ff3b1e64959edf@mail.gmail.com> <Pine.LNX.4.64.0812121559220.19722@blonde.anvils> <494292D4.6090302@redhat.com> <Pine.LNX.4.64.0812121733440.27074@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0812121733440.27074@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:

> Sorry, I'm still puzzled: I thought the unevictable lru was for
> shared file pages as well as for anon pages?  Of course I agree
> with you over the anons (and shm and tmpfs get counted along
> with the anons in this context), but wouldn't we still need
> an unevictable lru for mlocked shared file pages?

Good point, you are correct.  I had forgotten about that
part completely - keeping CONFIG_UNEVICTABLE_LRU may be
a good idea after all.

-- 
All Rights Reversed
