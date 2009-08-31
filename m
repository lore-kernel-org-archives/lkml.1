Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZHaCug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZHaCug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 22:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZHaCuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 22:50:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZHaCue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 22:50:34 -0400
Message-ID: <4A9B3A24.7050202@redhat.com>
Date: Sun, 30 Aug 2009 22:49:08 -0400
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
Subject: Re: [PATCH 14/23] io-conroller: Prepare elevator layer for single
 queue schedulers
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-15-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-15-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Elevator layer now has support for hierarchical fair queuing. cfq has
> been migrated to make use of it and now it is time to do groundwork for
> noop, deadline and AS.
> 
> noop deadline and AS don't maintain separate queues for different processes.
> There is only one single queue. Effectively one can think that in hierarchical
> setup, there will be one queue per cgroup where requests from all the
> processes in the cgroup will be queued.
> 
> Generally io scheduler takes care of creating queues. Because there is
> only one queue here, we have modified common layer to take care of queue
> creation and some other functionality. This special casing helps in keeping
> the changes to noop, deadline and AS to the minimum.
> 
> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
