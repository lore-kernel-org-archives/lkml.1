Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYDCU1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYDCU1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 16:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYDCU1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 16:27:43 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:42823 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbYDCU1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 16:27:42 -0400
Message-ID: <47F53DA2.3050403@linux.vnet.ibm.com>
Date: Fri, 04 Apr 2008 01:57:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, David Rientjes <rientjes@google.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org
Subject: Re: cgroup_disable=memory for 2.6.25?
References: <Pine.LNX.4.64.0804032055590.8157@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0804032055590.8157@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Hi Balbir,
> 
> I'm rather surprised that nobody has pushed -mm's
> 
> cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
> cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch
> memory-controller-make-memory-resource-control-aware-of-boot-options.patch
> 
> into 2.6.25: which was what I'd expected when I first suggested that
> distros might want a way to build with the potential for mem cgroups,
> but be able to switch off their significant overhead for everyone not
> interested.
> 
> Ballpark figures, I'm trying to get this question out rather than
> processing the exact numbers: CONFIG_CGROUP_MEM_RES_CTLR adds 15%
> overhead to the affected paths, booting with cgroup_disable=memory
> cuts that back to 1% overhead (due to slightly bigger struct page).
> 
> I'm no expert on distros, they may have no interest whatever in
> CONFIG_CGROUP_MEM_RES_CTLR=y; and the rest of us can easily build
> with or without it, or apply the cgroup_disable=memory patches.
> 
> But if those patches serve a purpose, shouldn't they be in 2.6.25?

Hi, Hugh,

I expected those patches to make it into 2.6.25. But ever since 2.6.25-rc5-mm1,
the next -mm was for 2.6.25-rc8. I have been meaning to follow up with Andrew,
but lost with some other patches.

Andrew,

Could we please push these patches upstream before 2.6.25? Or is it too late?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
