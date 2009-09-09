Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbZIIDkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbZIIDkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZIIDkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:40:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZIIDkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:40:16 -0400
Message-ID: <4AA72363.6000904@redhat.com>
Date: Tue, 08 Sep 2009 23:39:15 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
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
Subject: Re: [PATCH 24/23] io-controller: Don't leave a queue active when
 a	disk is idle
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <20090908222821.GB3558@redhat.com>
In-Reply-To: <20090908222821.GB3558@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o It is possible that when there is only a single queue in the system, it
>   remains unexpired for a long time (because there is no IO activity on the
>   disk). So when next request comes in after a long time, it might make
>   scheduler think that all this while queue used the disk and it will assign
>   a high vdisktime to the queue. Hence make sure queue is expired once all
>   the requests have completed from the queue.
> 
> o Also avoid unnecessarily expiring a queue when it has got one request
>   dispatched to the queue and waiting for it to finish and it does not have
>   more requests queued to dispatch.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
