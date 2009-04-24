Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbZDXJ6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbZDXJ6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZDXJ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:58:25 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:49224 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751725AbZDXJ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:58:24 -0400
Date: Fri, 24 Apr 2009 18:58:23 +0900 (JST)
Message-Id: <20090424.185823.104059944.ryov@valinux.co.jp>
To: baramsori72@gmail.com
Cc: righi.andrea@gmail.com, menage@google.com, balbir@linux.vnet.ibm.com,
       guijianfeng@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       lizf@cn.fujitsu.com, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, nauman@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, corsetproject@googlegroups.com
Subject: Re: [PATCH] range-bw: Another I/O scheduling policy of dm-ioband
 supporting the predicable I/O bandwidth (range bandwidth)
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <2891419e0904230210w40482535ma3fc25c1e429969d@mail.gmail.com>
References: <2891419e0904230210w40482535ma3fc25c1e429969d@mail.gmail.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3O9wdqu000979

Hi Dong-Jae,

> range-bw is based on newest version of dm-ioband, bio-cgroup V7(4
> patch files), dm-ioband-V1.10.3(1 patch file) and these can be
> referred in
> http://people.valinux.co.jp/~ryov/dm-ioband/
> http://people.valinux.co.jp/~ryov/bio-cgroup/
> and the below range-bw patch file(dm-ioband-rangebw-1.10.3.patch)
> including Ryoâ€™s patch set is also referred in:
> http://www.corsetproject.net/browser/corset_source_code/resource_controllers/disk_controller/Range-BW-for-dmioband-V1.10.3
> You have to apply this(dm-ioband-rangebw-1.10.3.patch) patch file
> after applying dm-ioband and bio-cgroup patches.
> 
> The released range-bw may have some problems and improper code
> although I try to test heavily. It is first release ^^
> And it is required to reduce the overhead of I/O scheduling and to
> optimize the source code.
> Any comments or advices is welcome
> 
> Ryo Tsuruta, Can you check this patch file ?
> for convenience, patch file is attached in this mail.

I took a quick look at your patch. It seems to be no problem for
existing dm-ioband code, but I would suggest you that you had better
use checkpatch.pl to check for your coding style.
The patch could be applied and compiled successfully. I did a simple
test, running fio on each cgroup in 30 seconds simultaneously, and got
the following results.

               w/o range-bw     w/ range-bw (min&max-bw settings)
cgroup1          331KB/s             102KB/s (100KB)
cgroup2          331KB/s             196KB/s (200KB)

Do you have any benchmark resutls? I'd be very interested to see it.

Thanks,
Ryo Tsuruta
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
