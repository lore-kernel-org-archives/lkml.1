Return-Path: <linux-kernel-owner+w=401wt.eu-S932484AbZHDGrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbZHDGrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 02:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZHDGrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 02:47:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62321 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbZHDGrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 02:47:19 -0400
Message-ID: <4A77D91C.7010009@cn.fujitsu.com>
Date: Tue, 04 Aug 2009 14:45:48 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH] io-controller: implement per group request allocation
 limitation
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <4A569FC5.7090801@cn.fujitsu.com> <4A779719.1070900@ds.jp.nec.com>
In-Reply-To: <4A779719.1070900@ds.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Munehiro Ikeda wrote:
> Gui Jianfeng wrote, on 07/09/2009 09:56 PM:
>> Hi Vivek,
>>
>> This patch exports a cgroup based per group request limits interface.
>> and removes the global one. Now we can use this interface to perform
>> different request allocation limitation for different groups.
>>
>> Signed-off-by: Gui Jianfeng<guijianfeng@cn.fujitsu.com>
> (snip)
> 
> Hi Jianfeng,
> 
> If this helps, again.
> 
> A patch posted from Gui Jianfeng on 2009/07/09 adds per-cgroup
> nr_requests control by io.nr_group_requests.  The patch missed to update
> iog->nr_congestion_{on|off} and this patch adds the missing-link.
> 
> Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>

  Yes, i'v fixed this issue for the global nr_group_requests updating in V6,
  but forgot to update it in this patch. Thanks :)

-- 
Regards
Gui Jianfeng

