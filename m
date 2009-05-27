Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbZE0D0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbZE0D0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZE0D0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:26:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51673 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbZE0D0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:26:39 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
In-Reply-To: <6.0.0.20.2.20090527120248.076abe38@172.19.0.2>
References: <20090527025721.GA11153@localhost> <6.0.0.20.2.20090527120248.076abe38@172.19.0.2>
Message-Id: <20090527122540.6897.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 27 May 2009 12:26:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >The numbers look too small for a 7 disk RAID:
> >> >
> >> >        > #dd if=testdir/testfile of=/dev/null bs=16384
> >> >        >
> >> >        > -2.6.30-rc6
> >> >        > 1048576+0 records in
> >> >        > 1048576+0 records out
> >> >        > 17179869184 bytes (17 GB) copied, 224.182 seconds, 76.6 MB/s
> >> >        >
> >> >        > -2.6.30-rc6-patched
> >> >        > 1048576+0 records in
> >> >        > 1048576+0 records out
> >> >        > 17179869184 bytes (17 GB) copied, 206.465 seconds, 83.2 MB/s
> >> >
> >> >I'd suggest you to configure the array properly before coming back to
> >> >measuring the impact of this patch.
> >> 
> >> 
> >> I created 16GB file to this disk array, and mounted to testdir, dd to 
> >this directory.
> >
> >I mean, you should get >300MB/s throughput with 7 disks, and you
> >should seek ways to achieve that before testing out this patch :-)
> 
> Throughput number of storage array is very from one product to another.
> On my hardware environment I think this number is valid and
> my patch is effective.

Hifumi-san, if you really want to merge, you should reproduce this
issue on typical hardware, I think.



