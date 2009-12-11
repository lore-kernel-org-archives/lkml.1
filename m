Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZLKNsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZLKNsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbZLKNs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:48:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757447AbZLKNs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:48:28 -0500
Message-ID: <4B224D9C.6070804@redhat.com>
Date: Fri, 11 Dec 2009 08:48:12 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: lwoodman@redhat.com
CC: Minchan Kim <minchan.kim@gmail.com>, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091210185626.26f9828a@cuia.bos.redhat.com> <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com> <4B2235F0.4080606@redhat.com>
In-Reply-To: <4B2235F0.4080606@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2009 07:07 AM, Larry Woodman wrote:
> Minchan Kim wrote:
>>
>> I like this. but why do you select default value as constant 8?
>> Do you have any reason?
>>
>> I think it would be better to select the number proportional to NR_CPU.
>> ex) NR_CPU * 2 or something.
>>
>> Otherwise looks good to me.
>>
>> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>>
> This is a per-zone count so perhaps a reasonable default is the number
> of CPUs on the
> NUMA node that the zone resides on ?

One reason I made it tunable is so people can easily test
what a good value would be :)

-- 
All rights reversed.
