Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYIYOvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYIYOvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYIYOvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:51:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59656 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbYIYOvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:51:41 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/3] Report the pagesize backing a VMA in /proc/pid/smaps
Cc: kosaki.motohiro@jp.fujitsu.com, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <1222202736-13311-2-git-send-email-mel@csn.ul.ie>
References: <1222202736-13311-1-git-send-email-mel@csn.ul.ie> <1222202736-13311-2-git-send-email-mel@csn.ul.ie>
Message-Id: <20080925234913.58AE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Sep 2008 23:51:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is useful to verify a hugepage-aware application is using the expected
> pagesizes for its memory regions. This patch creates an entry called
> KernelPageSize in /proc/pid/smaps that is the size of page used by the kernel
> to back a VMA. The entry is not called PageSize as it is possible the MMU
> uses a different size. This extension should not break any sensible parser
> that skips lines containing unrecognised information.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

looks good to me.
and, I tested this patch on x86_64 mmotm 0923 and it works well.


Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



