Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbZANHN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbZANHN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZANHNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:13:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58011 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbZANHNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:13:47 -0500
Message-ID: <496D9077.3060705@cn.fujitsu.com>
Date: Wed, 14 Jan 2009 15:12:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rakib Mullick <rakib.mullick@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] memcg: fix section mismatch
References: <496D8E80.8070401@cn.fujitsu.com> <20090114160758.159415f5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090114160758.159415f5.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 14 Jan 2009 15:04:32 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> At system boot when creating the top cgroup, mem_cgroup_create() calls
>> enable_swap_cgroup() which is marked as __init, so mark mem_cgroup_create()
>> as __ref to avoid false section mismatch warning.
>>
>> Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Acked-by; KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
>> ---
>>
>> use __ref instead of __init_refok
>>
> change log ?
> 

Yes. But for this simple patch, I don't think change log for v1 -> v2 is worth
anything for the normal changelog. :)
