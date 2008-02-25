Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYBYRmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYBYRmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYBYRmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:42:31 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:39427 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYBYRma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:42:30 -0500
Message-ID: <47C2FCC1.7090203@linux.vnet.ibm.com>
Date: Mon, 25 Feb 2008 23:07:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Memory Resource Controller Add Boot Option
References: <20080225115509.23920.66231.sendpatchset@localhost.localdomain> <20080225115550.23920.43199.sendpatchset@localhost.localdomain> <6599ad830802250816m1f83dbeekbe919a60d4b51157@mail.gmail.com> <47C2F86A.9010709@linux.vnet.ibm.com> <6599ad830802250932s5eaa3bcchbfc49fe0e76d3f7d@mail.gmail.com>
In-Reply-To: <6599ad830802250932s5eaa3bcchbfc49fe0e76d3f7d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Feb 25, 2008 at 9:18 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  I thought about it, but it did not work out all that well. The reason being,
>>  that the memory controller is called in from places besides cgroup.
>>  mem_cgroup_charge_common() for example is called from several places in mm.
>>  Calling into cgroups to check, enabled/disabled did not seem right.
> 
> You wouldn't need to call into cgroups - if it's a flag in the subsys
> object (which is defined in memcontrol.c) you'd just say
> 
> if (mem_cgroup_subsys.disabled) {
> ...
> }
> 
> I'll send out a prototype for comment.

Sure thing, if css has the flag, then it would nice. Could you wrap it up to say
something like css_disabled(&mem_cgroup_subsys)


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
