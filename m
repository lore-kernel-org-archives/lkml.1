Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbZI1HiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbZI1HiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 03:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZI1HiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 03:38:09 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:46475 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZI1HiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 03:38:08 -0400
Date: Mon, 28 Sep 2009 16:38:11 +0900 (JST)
Message-Id: <20090928.163811.104053649.ryov@valinux.co.jp>
To: riel@redhat.com
Cc: vgoyal@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
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
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <4ABCDBFF.1020203@redhat.com>
References: <20090925050429.GB12555@redhat.com>
	<20090925.180724.104041942.ryov@valinux.co.jp>
	<4ABCDBFF.1020203@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

Rik van Riel <riel@redhat.com> wrote:
> Ryo Tsuruta wrote:
> 
> > Because dm-ioband provides faireness in terms of how many IO requests
> > are issued or how many bytes are transferred, so this behaviour is to
> > be expected. Do you think fairness in terms of IO requests and size is
> > not fair?
> 
> When there are two workloads competing for the same
> resources, I would expect each of the workloads to
> run at about 50% of the speed at which it would run
> on an uncontended system.
> 
> Having one of the workloads run at 95% of the
> uncontended speed and the other workload at 5%
> is "not fair" (to put it diplomatically).

As I wrote in the mail to Vivek, I think that providing multiple
policies, on a per disk time basis, on a per iosize basis, maximum
rate limiting or etc would be good for users.

Thanks,
Ryo Tsuruta
