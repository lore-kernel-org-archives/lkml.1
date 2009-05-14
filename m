Return-Path: <linux-kernel-owner+w=401wt.eu-S1761958AbZENBAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761958AbZENBAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 21:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZENBA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 21:00:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49867 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbZENBAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 21:00:25 -0400
Message-ID: <4A0B6CEE.90907@cn.fujitsu.com>
Date: Thu, 14 May 2009 08:59:26 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH] IO Controller: Add per-device weight and ioprio_class
 handling
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A0A29B5.7030109@cn.fujitsu.com> <20090513144432.GA7696@redhat.com>
In-Reply-To: <20090513144432.GA7696@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Wed, May 13, 2009 at 10:00:21AM +0800, Gui Jianfeng wrote:
>> Hi Vivek,
>>
>> This patch enables per-cgroup per-device weight and ioprio_class handling.
>> A new cgroup interface "policy" is introduced. You can make use of this 
>> file to configure weight and ioprio_class for each device in a given cgroup.
>> The original "weight" and "ioprio_class" files are still available. If you
>> don't do special configuration for a particular device, "weight" and 
>> "ioprio_class" are used as default values in this device.
>>
>> You can use the following format to play with the new interface.
>> #echo DEV:weight:ioprio_class > /patch/to/cgroup/policy
>> weight=0 means removing the policy for DEV.
>>
> 
> Thanks for the patch Gui. I will test it out and let you know how does
> it go.

  Hi Vivek,

  I forgot to mention that this patch isn't tested through, just for showing
  the design. I'd like to test it soon.
  

> 
> Thanks
> Vivek
> 

-- 
Regards
Gui Jianfeng

