Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbZE0Cfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbZE0Cfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZE0CfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:35:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51928 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbZE0CfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:35:24 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
In-Reply-To: <6.0.0.20.2.20090527110937.0770c420@172.19.0.2>
References: <20090527020909.GB17658@localhost> <6.0.0.20.2.20090527110937.0770c420@172.19.0.2>
Message-Id: <20090527113211.6891.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 27 May 2009 11:35:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >even consumed 9% of a CPU, so where on earth has the kernel gone to?
> >> >
> >> >Have you been able to reproduce this in your testing?
> >> 
> >> Yes, this test on my environment is reproducible.
> >
> >Hisashi, does your environment have some special configurations?
> 
> Hi.
> My testing environment is as follows:
> Hardware: HP DL580 
> CPU:Xeon 3.2GHz *4 HT enabled
> Memory:8GB
> Storage: Dothill SANNet2 FC (7Disks RAID-0 Array)
> 
> I did dd to this disk-array and got improved performance number.
> 
> I noticed that when a disk is just one HDD, performance improvement
> is very small.

thas's odd.

Why your patch depend on transfer rate difference?





