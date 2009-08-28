Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbZH1W1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbZH1W1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZH1W1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:27:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbZH1W1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:27:48 -0400
Message-ID: <4A9859B0.6090906@redhat.com>
Date: Fri, 28 Aug 2009 18:26:56 -0400
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
Subject: Re: [PATCH 02/23] io-controller: Core of the elevator fair queuing
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o This is core of the io scheduler implemented at elevator layer. This is a mix
>   of cpu CFS scheduler and CFQ IO scheduler. Some of the bits from CFS have
>   to be derived so that we can support hierarchical scheduling. Without
>   cgroups or with-in group, we should essentially get same behavior as CFQ.
> 
> o This patch only shows non-hierarchical bits. Hierarhical code comes in later
>   patches.
> 
> o This code is the building base of introducing fair queuing logic in common
>   elevator layer so that it can be used by all the four IO schedulers.
> 
> Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
> Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
