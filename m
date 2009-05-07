Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbZEGATQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbZEGATQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758953AbZEGAS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:18:58 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:59065 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756075AbZEGAS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:18:58 -0400
Date: Thu, 07 May 2009 09:18:58 +0900 (JST)
Message-Id: <20090507.091858.226775723.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: akpm@linux-foundation.org, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, jens.axboe@oracle.com, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, peterz@infradead.org
Subject: Re: IO scheduler based IO Controller V2
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090506023332.GA1212@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
	<20090505132441.1705bfad.akpm@linux-foundation.org>
	<20090506023332.GA1212@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> Ryo, dm-ioband breaks the notion of classes and priority of CFQ because
> of FIFO dispatch of buffered bios. Apart from that it tries to provide
> fairness in terms of actual IO done and that would mean a seeky workload
> will can use disk for much longer to get equivalent IO done and slow down
> other applications. Implementing IO controller at IO scheduler level gives
> us tigher control. Will it not meet your requirements? If you got specific
> concerns with IO scheduler based contol patches, please highlight these and
> we will see how these can be addressed.

I'd like to avoid making complicated existing IO schedulers and other
kernel codes and to give a choice to users whether or not to use it.
I know that you chose an approach that using compile time options to
get the same behavior as old system, but device-mapper drivers can be
added, removed and replaced while system is running.

Thanks,
Ryo Tsuruta
