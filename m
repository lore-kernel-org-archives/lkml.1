Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYLLT0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYLLT0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYLLT0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:26:14 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:40103 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbYLLT0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:26:09 -0500
Date: Fri, 12 Dec 2008 19:26:24 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jean Delvare <khali@linux-fr.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
In-Reply-To: <4942A6C5.1090606@redhat.com>
Message-ID: <Pine.LNX.4.64.0812121922530.25203@blonde.anvils>
References: <20081211202923.330F.KOSAKI.MOTOHIRO@jp.fujitsu.com> 
 <20081211113646.GI23742@kernel.dk>  <20081211204006.3312.KOSAKI.MOTOHIRO@jp.fujitsu.com>
  <20081212075844.GH23742@kernel.dk> <49426C16.6040108@redhat.com>
 <2f11576a0812120711l130e07c3x94ff3b1e64959edf@mail.gmail.com>
 <Pine.LNX.4.64.0812121559220.19722@blonde.anvils> <494292D4.6090302@redhat.com>
 <Pine.LNX.4.64.0812121733440.27074@blonde.anvils> <4942A6C5.1090606@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008, Rik van Riel wrote:
> 
> keeping CONFIG_UNEVICTABLE_LRU may be a good idea after all.

Do you mean, keeping the CONFIG_UNEVICTABLE_LRU codepath even
when CONFIG_SWAP=n is a good idea?  Or do you see a reason we
actually still need CONFIG_UNEVICTABLE_LRU as an option?

It does add about 2.6k to kernel text (YMMV), is saving that
worth the extra config option?  For others to vote, really.

Hugh
