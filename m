Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZHaRft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZHaRft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbZHaRft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:35:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbZHaRfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:35:48 -0400
Message-ID: <4A9C09BE.4060404@redhat.com>
Date: Mon, 31 Aug 2009 13:34:54 -0400
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
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches from Ryo to
 track async bios.
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-19-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-19-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o blkio_cgroup patches from Ryo to track async bios.
> 
> o This functionality is used to determine the group of async IO from page
>   instead of context of submitting task.
> 
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

This seems to be the most complex part of the code so far,
but I see why this code is necessary.

Acked-by: Rik van Riel <riel@redhat.com>

