Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZHaP14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZHaP14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZHaP1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:27:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZHaP1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:27:55 -0400
Message-ID: <4A9BEBCF.7000808@redhat.com>
Date: Mon, 31 Aug 2009 11:27:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 13/23] io-controller: Separate out queue and data
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-14-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-14-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o So far noop, deadline and AS had one common structure called *_data which
>   contained both the queue information where requests are queued and also
>   common data used for scheduling. This patch breaks down this common
>   structure in two parts, *_queue and *_data. This is along the lines of
>   cfq where all the reuquests are queued in queue and common data and tunables
>   are part of data.
> 
> o It does not change the functionality but this re-organization helps once
>   noop, deadline and AS are changed to use hierarchical fair queuing.
> 
> o looks like queue_empty function is not required and we can check for
>   q->nr_sorted in elevator layer to see if ioscheduler queues are empty or
>   not.
> 
> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

