Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbYEFIRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbYEFIRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbYEFIQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:16:42 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:36560 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYEFIQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:16:41 -0400
Message-ID: <482013B0.5040405@linux.vnet.ibm.com>
Date: Tue, 06 May 2008 13:45:44 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 1/4] Setup the rlimit controller
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain> <20080503213736.3140.83278.sendpatchset@localhost.localdomain> <481FB50D.1070308@cn.fujitsu.com>
In-Reply-To: <481FB50D.1070308@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Balbir Singh wrote:
>> +struct cgroup_subsys rlimit_cgroup_subsys;
>> +
>> +struct rlimit_cgroup {
>> +	struct cgroup_subsys_state css;
>> +	struct res_counter as_res;	/* address space counter */
>> +};
>> +
>> +static struct rlimit_cgroup init_rlimit_cgroup;
>> +
>> +struct rlimit_cgroup *rlimit_cgroup_from_cgrp(struct cgroup *cgrp)
> 
> It can be static if I don't miss anything.

Yes, it can be. Thanks!

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
