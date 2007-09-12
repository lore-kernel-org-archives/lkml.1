Return-Path: <linux-kernel-owner+w=401wt.eu-S933739AbXILKJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbXILKJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 06:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761234AbXILKJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 06:09:49 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:49736 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761159AbXILKJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 06:09:48 -0400
Message-ID: <46E7B9DA.6070404@linux.vnet.ibm.com>
Date: Wed, 12 Sep 2007 15:35:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Eric W Biederman <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [-mm PATCH 1/9] Memory controller resource counters (v6)
References: <20070817084228.26003.12568.sendpatchset@balbir-laptop> <20070817084238.26003.7733.sendpatchset@balbir-laptop> <6599ad830709101742k658234b4of59f14ef27e40d14@mail.gmail.com>
In-Reply-To: <6599ad830709101742k658234b4of59f14ef27e40d14@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Hi Balbir/Pavel,
> 
> As I mentioned to you directly at the kernel summit, I think it might
> be cleaner to integrate resource counters more closely with control
> groups. So rather than controllers such as the memory controller
> having to create their own boilerplate cf_type structures and
> read/write functions, it should be possible to just call a function
> something like
> 
> control_group_add_rescounter(struct cgroup *cg, struct cgroup_subsys *ss,
>                                              struct res_counter *res,
> const char *name)
> 
> and have it handle all the userspace API. This would simplify the task
> of keeping a consistent userspace API between different controllers
> using the resource counter abstraction.
> 
> Paul
> 

Yes, I remember discussing it with you. I would expect res_counters
definition to be dynamic (to be able to add the guarantee, soft limit,
etc) for expansion in the future. In the future, I would also like
to do hierarchical resource groups, the hierarchy would represent
the current filesystem hierarchy.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
