Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYGXGOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYGXGOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 02:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYGXGOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 02:14:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57611 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbYGXGOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 02:14:42 -0400
Date: Thu, 24 Jul 2008 15:14:29 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
Subject: Re: [RFC][PATCH][0/3] introduce rlimit cgroup
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       menage@google.com
In-Reply-To: <488722DF.9080003@miraclelinux.com>
References: <488722DF.9080003@miraclelinux.com>
Message-Id: <20080724150557.8697.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nakagawa-san,

> Hello,
> 
> I think existing rlimit interface isn't useful.

Why it isn't useful?
Please explain your motivation.

> So I created rlimit interface on cgroup.
> Do you think this is a proper way todo it? (or Is there any similar methods already?)

your rlimit controller is merely setting process rlimit to each task in the group.
So, it isn't almost people required action.

At least, I don't think useful.

> # cat /dev/cgroup/rlimit.limits
> Number  Limit                  Soft Limit       Hard Limit       Unit
> 0       Max cpu time           unlimited        unlimited         ms
> 1       Max file size          unlimited        unlimited         bytes
> 2       Max data size          unlimited        unlimited         bytes
> 3       Max stack size         8388608          unlimited         bytes
> 4       Max core file size     0                unlimited         bytes
> 5       Max resident set       unlimited        unlimited         bytes
> 6       Max processes          16300            16300             processes
> 7       Max open files         1024             1024              files
> 8       Max locked memory      32768            32768             bytes
> 9       Max address space      unlimited        unlimited         bytes
> 10      Max file locks         unlimited        unlimited         locks
> 11      Max pending signals    16300            16300             signals
> 12      Max msgqueue size      819200           819200           bytes
> 13      Max nice priority       0                0
> 14      Max realtime priority   0                0
> 15      Max realtime timeout    unlimited        unlimited        us
> # echo "1 100000000 200000000" > /dev/cgroup/rlimit.limits
> # cat /proc/zero > /tmp/hoge

in general, A complex setting file is thought as ugly.
Why can't separate it?




