Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYFYXvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYFYXvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYFYXvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:51:41 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:43020 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYFYXvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:51:40 -0400
Message-ID: <4862DA05.7000902@linux.vnet.ibm.com>
Date: Thu, 26 Jun 2008 05:21:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: yamamoto@valinux.co.jp, menage@google.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [2/2] memrlimit fix usage of tmp as a parameter name
References: <20080620150132.16094.29151.sendpatchset@localhost.localdomain> <20080620150152.16094.76790.sendpatchset@localhost.localdomain> <20080625164121.9146fb56.akpm@linux-foundation.org>
In-Reply-To: <20080625164121.9146fb56.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 20 Jun 2008 20:31:52 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Fix the variable tmp being used in write_strategy. This patch replaces tmp
>> with val, the fact that it is an output parameter can be interpreted from
>> the pass by reference.
> 
> Paul's "CGroup Files: Convert res_counter_write() to be a cgroups
> write_string() handler"
> (memrlimit-setup-the-memrlimit-controller-cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-memrlimitcgroup.patch)
> deleted memrlimit_cgroup_write_strategy(), so problem solved ;)

Yes, I remember reviewing those patches. Nice to have problems solved
automatically :)

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
