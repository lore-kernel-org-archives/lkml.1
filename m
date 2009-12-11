Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbZLKMNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbZLKMNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbZLKMNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:13:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbZLKMNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:13:05 -0500
Message-ID: <4B2235F0.4080606@redhat.com>
Date: Fri, 11 Dec 2009 07:07:12 -0500
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
Organization: RedHat
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Rik van Riel <riel@redhat.com>, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091210185626.26f9828a@cuia.bos.redhat.com> <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com>
In-Reply-To: <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:
>
> I like this. but why do you select default value as constant 8?
> Do you have any reason?
>
> I think it would be better to select the number proportional to NR_CPU.
> ex) NR_CPU * 2 or something.
>
> Otherwise looks good to me.
>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>
>   
This is a per-zone count so perhaps a reasonable default is the number 
of CPUs on the
NUMA node that the zone resides on ?

