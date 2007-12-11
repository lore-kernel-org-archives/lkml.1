Return-Path: <linux-kernel-owner+w=401wt.eu-S1750984AbXLKF0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbXLKF0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 00:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbXLKFZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 00:25:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36217 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbXLKFZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 00:25:57 -0500
Date: Tue, 11 Dec 2007 14:29:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "riel@redhat.com" <riel@redhat.com>
Subject: Re: [PATCH][for -mm] fix accounting in vmscan.c for memory
 controller
Message-Id: <20071211142911.4b8091d2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <475E1CBC.4070408@linux.vnet.ibm.com>
References: <20071211112644.221a8dc5.kamezawa.hiroyu@jp.fujitsu.com>
	<475E1CBC.4070408@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 10:44:36 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Looks good to me.
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> TODO:
> 
> 1. Should we have vm_events for the memory controller as well?
>    May be in the longer term
> 

ALLOC_STALL is recoreded as failcnt, I think.
I think DIRECT can be accoutned easily.

But I'm not in hurry very much, because all reclaimation is DIRECT, now.
After we implement background reclaim, we should consider it.

Thanks,
-Kame

