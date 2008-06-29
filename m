Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYF2ILK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYF2ILK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 04:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYF2IKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 04:10:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46642 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYF2IKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 04:10:50 -0400
Date: Sun, 29 Jun 2008 17:09:50 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] splitlru: shmem_getpage SetPageSwapBacked sooner
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
Message-Id: <20080629170839.37C7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> shmem_getpage must SetPageSwapBacked before the mem_cgroup_cache_charge,
> otherwise try_to_free_mem_cgroup_pages cannot find the shmem/tmpfs pages
> it needs to free, and OOMs result.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

it seems makes sense.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


