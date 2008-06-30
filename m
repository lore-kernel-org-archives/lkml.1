Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYF3G1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYF3G1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYF3G10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:27:26 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:54027 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752794AbYF3G1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:27:25 -0400
Message-ID: <48687CB9.4090505@linux.vnet.ibm.com>
Date: Mon, 30 Jun 2008 11:57:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: further checking of disabled flag
References: <Pine.LNX.4.64.0806290108110.20280@blonde.site> <Pine.LNX.4.64.0806290115440.20280@blonde.site> <20080630112608.94fe4762.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080630112608.94fe4762.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Sun, 29 Jun 2008 01:17:17 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
>> Further adjustments to the mem_cgroup_subsys.disabled tests: add one to
>> mem_cgroup_shrink_usage; move mem_cgroup_charge_common's into its callers,
>> before they've done any work; and add one to mem_cgroup_move_lists, to
>> avoid the overhead of its bit spin locking and unlocking.
>>
>> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> seems better
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
