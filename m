Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYKJCvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYKJCvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 21:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYKJCvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 21:51:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58753 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbYKJCvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 21:51:37 -0500
Message-ID: <4917A116.7040603@cn.fujitsu.com>
Date: Mon, 10 Nov 2008 10:48:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: vgoyal@redhat.com
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/4] io controller: documentation
References: <20081106153022.215696930@redhat.com> <20081106153135.743458085@redhat.com>
In-Reply-To: <20081106153135.743458085@redhat.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vivek

Thanks for your work. :)

A question below.

> +For example, assume there are two cgroups A and B with weights 1024 and 2048
> +in the system. Tasks in two cgroups A and B are doing IO to two disks sda and
> +sdb in the system. A user has enabled IO control on both sda and sdb. Now on
> +both sda and sdb, tasks in cgroup B will get to use 2/3 of disk BW and
> +tasks in cgroup A will get to use 1/3 of disk bandwidth, only in case of
> +contention. If tasks in any of the groups stop doing IO to a particular disk,
> +task in other group will get to use full disk BW for that duration.
> +

So in this example, I can't assign 1/3 of sda's disk BW while 2/3 of sdb's
disk BW to A. Am I right?
