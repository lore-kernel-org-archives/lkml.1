Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0CEAou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 19:44:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52850 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab0CEAot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 19:44:49 -0500
Message-ID: <4B905297.7030306@cn.fujitsu.com>
Date: Fri, 05 Mar 2010 08:38:47 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: vgoyal@redhat.com, jens.axboe@oracle.com,
       Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 2/2 V2] io-controller: Document for blkio.weight_device
References: <4B8DFFD7.2000908@cn.fujitsu.com>	 <20100303143311.GA2866@redhat.com> <20100303154748.GC2866@redhat.com>	 <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com> <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com> <4B8F27BD.2020704@cn.fujitsu.com> <4B8F62C7.10500@cn.fujitsu.com> <4B8F97E8.6020806@oss.ntt.co.jp>
In-Reply-To: <4B8F97E8.6020806@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takuya Yoshikawa wrote:
> Hi, I found a typo.
> 
> Gui Jianfeng wrote:
>> +- blkio.weight_device
>> +    - One can specify per cgroup per device rules using this interface.
>> +      These rules override the default value of group weight as
>> specified
>> +      by blkio.weight.
>> +
>> +      Following is the format.
>> +
>> +      #echo dev_maj:dev_minor weight >
>> /patch/to/cgroup/blkio.weight_device
> 
>                                   You mean "path to"?
> 

yeah, will fix.

Thanks
Gui

> Thanks,
>   Takuya
> 
>> +
>> +      weight=0 means removing weight on a given device.
>> +
>> +      Examples:
>> +      Configure weight=300 on /dev/sdb (8:16) in this cgroup
>> +      # echo 8:16 300 > blkio.weight_device
>> +      # cat blkio.weight_device
>> +      dev     weight
>> +      8:16    300
>> +
>> +      Configure weight=500 on /dev/sda (8:0) in this cgroup
>> +      # echo 8:0 500 > blkio.weight_device
>> +      # cat blkio.weight_device
>> +      dev     weight
>> +      8:0     500
>> +      8:16    300
>> +
>> +      Remove specific weight for /dev/sda in this cgroup
>> +      # echo 8:0 0 > blkio.weight_device
>> +      # cat blkio.weight_device
>> +      dev     weight
>> +      8:16    300
>> +
>>  CFQ sysfs tunable
>>  =================
>>  /sys/block/<disk>/queue/iosched/group_isolation
> 
> 
> 
> 

