Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbZDQHcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbZDQHcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZDQHcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:32:11 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:60971 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753295AbZDQHcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:32:09 -0400
Date: Fri, 17 Apr 2009 16:32:08 +0900 (JST)
Message-Id: <20090417.163208.39173254.ryov@valinux.co.jp>
To: yoshikawa.takuya@oss.ntt.co.jp
Cc: righi.andrea@gmail.com, menage@google.com, balbir@linux.vnet.ibm.com,
       guijianfeng@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, lizf@cn.fujitsu.com, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <49E7E037.9080004@oss.ntt.co.jp>
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
	<1239740480-28125-4-git-send-email-righi.andrea@gmail.com>
	<49E7E037.9080004@oss.ntt.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH 3/9] bio-cgroup controller
Date: Fri, 17 Apr 2009 10:49:43 +0900

> > +config CGROUP_BIO
> > +	bool "Block I/O cgroup subsystem"
> > +	depends on CGROUPS && BLOCK
> > +	select MM_OWNER
> > +	help
> > +	  Provides a Resource Controller which enables to track the onwner
> > +	  of every Block I/O requests.
> > +	  The information this subsystem provides can be used from any
> > +	  kind of module such as dm-ioband device mapper modules or
> > +	  the cfq-scheduler.
>
>o I can understand this kind of information will be effective for io
>   controllers but how about cfq-scheduler? Don't we need some changes to
>   make cfq use this kind of information?

You need to modify cfq-scheduler to use bio-cgruop.

Thanks,
Ryo Tsuruta
