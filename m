Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbYAKEgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbYAKEgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 23:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbYAKEgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 23:36:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38067 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbYAKEgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 23:36:46 -0500
Date: Fri, 11 Jan 2008 13:36:03 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 10/19] No Reclaim LRU Infrastructure
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <20080108210008.383114457@redhat.com>
References: <20080108205939.323955454@redhat.com> <20080108210008.383114457@redhat.com>
Message-Id: <20080111133048.FD5C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik

> +config NORECLAIM
> +	bool "Track non-reclaimable pages (EXPERIMENTAL; 64BIT only)"
> +	depends on EXPERIMENTAL && 64BIT
> +	help
> +	  Supports tracking of non-reclaimable pages off the [in]active lists
> +	  to avoid excessive reclaim overhead on large memory systems.  Pages
> +	  may be non-reclaimable because:  they are locked into memory, they
> +	  are anonymous pages for which no swap space exists, or they are anon
> +	  pages that are expensive to unmap [long anon_vma "related vma" list.]

Why do you select to default is NO ?
I think this is really improvement and no one of 64bit user
hope turn off without NORECLAIM developer :)


- kosaki


