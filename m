Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbYGDBtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbYGDBtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbYGDBti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:49:38 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35433 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbYGDBth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:49:37 -0400
Message-ID: <486D81B1.1020609@linux.vnet.ibm.com>
Date: Fri, 04 Jul 2008 07:19:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2.6.26-rc8-mm1] memrlimit: fix mmap_sem deadlock
References: <Pine.LNX.4.64.0807032143110.10641@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0807032143110.10641@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> "ps -f" hung after "killall make" of make -j20 kernel builds.  It's
> generally considered bad manners to down_write something you already
> have down_read.  exit_mm up_reads before calling mm_update_next_owner,
> so I guess exec_mmap can safely do so too.  (And with that repositioning
> there's not much point in mm_need_new_owner allowing for NULL mm.)
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Thanks!

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
