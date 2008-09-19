Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYISLcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYISLcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 07:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYISLbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 07:31:55 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:40273 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752054AbYISLby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 07:31:54 -0400
Date: Fri, 19 Sep 2008 20:31:53 +0900 (JST)
Message-Id: <20080919.203153.183041336.ryov@valinux.co.jp>
To: yoshikawa.takuya@oss.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, agk@sourceware.org
Subject: Re: dm-ioband + bio-cgroup benchmarks
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <48D36794.6010002@oss.ntt.co.jp>
References: <20080918.210418.226794540.ryov@valinux.co.jp>
	<48D36794.6010002@oss.ntt.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoshikawa-san,

> When you have time, would you explain me how you succeeded to check the
> time, bandwidth, especially when you did write() tests? Actually, I tried
> similar tests and failed to check the bandwidth correctly. Did you insert
> something in the kernel source?

I'm using our own tool, which issues I/Os in prallel in a specified
period and counts up how many I/Os are issued and how many bytes are
transferred in the period.

I'm also using our own tool for measurement of throughput variation to
see the internal data of dm-ioband. This tool is implemented as a
kernel module.

Thanks,
Ryo Tsuruta
