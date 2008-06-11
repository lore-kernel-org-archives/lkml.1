Return-Path: <linux-kernel-owner+w=401wt.eu-S1765142AbYFKRyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765142AbYFKRyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 13:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYFKRyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 13:54:23 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35581 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYFKRyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:54:22 -0400
Message-ID: <48500C66.7040807@linux.vnet.ibm.com>
Date: Wed, 11 Jun 2008 23:03:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: righi.andrea@gmail.com
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain> <20080521152948.15001.39361.sendpatchset@localhost.localdomain> <4850070F.6060305@gmail.com>
In-Reply-To: <4850070F.6060305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> Balbir Singh wrote:
>> +static int memrlimit_cgroup_write_strategy(char *buf, unsigned long
>> long *tmp)
>> +{
>> +    *tmp = memparse(buf, &buf);
>> +    if (*buf != '\0')
>> +        return -EINVAL;
>> +
>> +    *tmp = PAGE_ALIGN(*tmp);
>> +    return 0;
>> +}
> 
> We shouldn't use PAGE_ALIGN() here, otherwise we limit the address space
> to 4GB on 32-bit architectures (that could be reasonable, because this
> is a per-cgroup limit and not per-process).
> 

You mean un-reasonable?

> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>

Seems fair enough.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
