Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbYF3G02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbYF3G02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYF3G0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:26:17 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:48586 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752777AbYF3G0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:26:17 -0400
Message-ID: <48687C79.3060806@linux.vnet.ibm.com>
Date: Mon, 30 Jun 2008 11:56:01 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix shmem_unuse_inode charging
References: <Pine.LNX.4.64.0806290108110.20280@blonde.site> <20080630112347.76ed11a7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080630112347.76ed11a7.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Sun, 29 Jun 2008 01:13:20 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
>> The mem_cgroup_cache_charge in shmem_unuse_inode has been moved after
>> the radix_tree_preload, so generating a BUG: sleeping function called
>> from invalid context.  Move it back, uncharging where necessary.
>>
>> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> Sure, thanks,
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
