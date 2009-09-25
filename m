Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbZIYPGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbZIYPGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 11:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZIYPGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 11:06:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbZIYPGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 11:06:54 -0400
Message-ID: <4ABCDBFF.1020203@redhat.com>
Date: Fri, 25 Sep 2009 11:04:31 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: vgoyal@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: IO scheduler based IO controller V10
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>	<20090924143315.781cd0ac.akpm@linux-foundation.org>	<20090925050429.GB12555@redhat.com> <20090925.180724.104041942.ryov@valinux.co.jp>
In-Reply-To: <20090925.180724.104041942.ryov@valinux.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta wrote:

> Because dm-ioband provides faireness in terms of how many IO requests
> are issued or how many bytes are transferred, so this behaviour is to
> be expected. Do you think fairness in terms of IO requests and size is
> not fair?

When there are two workloads competing for the same
resources, I would expect each of the workloads to
run at about 50% of the speed at which it would run
on an uncontended system.

Having one of the workloads run at 95% of the
uncontended speed and the other workload at 5%
is "not fair" (to put it diplomatically).

-- 
All rights reversed.
