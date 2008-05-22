Return-Path: <linux-kernel-owner+w=401wt.eu-S935082AbYEVKPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082AbYEVKPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933330AbYEVKPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:15:39 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:48549 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935504AbYEVKPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:15:38 -0400
Message-ID: <4835477D.1020609@linux.vnet.ibm.com>
Date: Thu, 22 May 2008 15:44:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 3/4] cgroup mm owner callback changes to add task
 info (v5)
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain> <20080521152959.15001.14495.sendpatchset@localhost.localdomain> <20080521211958.ca4f733c.akpm@linux-foundation.org>
In-Reply-To: <20080521211958.ca4f733c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 21 May 2008 20:59:59 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> This patch adds an additional field to the mm_owner callbacks. This field
>> is required to get to the mm that changed. Hold mmap_sem in write mode
>> before calling the mm_owner_changed callback
>>
>> ...
>>
>> + * The callbacks are invoked with mmap_sem held in read mode.
> 
> Is that true?
> 
>> +	down_write(&mm->mmap_sem);
>> ...
>>  	cgroup_mm_owner_callbacks(mm->owner, c);
> 
> Looks like write-mode to me?

Yes, obsolete comment. Will fix.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
