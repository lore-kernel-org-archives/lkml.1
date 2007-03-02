Return-Path: <linux-kernel-owner+w=401wt.eu-S1422821AbXCBF3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422821AbXCBF3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 00:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422914AbXCBF3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 00:29:32 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:51891 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422821AbXCBF3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 00:29:31 -0500
Message-ID: <45E7B0E9.3040202@in.ibm.com>
Date: Fri, 02 Mar 2007 10:36:49 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: menage@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru, pj@sgi.com,
       sam@vilain.net, ebiederm@xmission.com, winget@google.com,
       containers@lists.osdl.org, serue@us.ibm.com, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 1/2] rcfs core patch
References: <20070301133543.GK15509@in.ibm.com> <20070301134528.GL15509@in.ibm.com>
In-Reply-To: <20070301134528.GL15509@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> Heavily based on Paul Menage's (inturn cpuset) work. The big difference
> is that the patch uses task->nsproxy to group tasks for resource control
> purpose (instead of task->containers).
> 
> The patch retains the same user interface as Paul Menage's patches. In
> particular, you can have multiple hierarchies, each hierarchy giving a 
> different composition/view of task-groups.
> 
> (Ideally this patch should have been split into 2 or 3 sub-patches, but
> will do that on a subsequent version post)
> 

With this don't we end up with a lot of duplicate between cpusets and rcfs.


> Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>
> Signed-off-by : Paul Menage <menage@google.com>
> 
> 
> ---
> 
>  linux-2.6.20-vatsa/include/linux/init_task.h |    4 
>  linux-2.6.20-vatsa/include/linux/nsproxy.h   |    5 
>  linux-2.6.20-vatsa/init/Kconfig              |   22 
>  linux-2.6.20-vatsa/init/main.c               |    1 
>  linux-2.6.20-vatsa/kernel/Makefile           |    1 
> 
> 
> ---

The diffstat does not look quite right.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
