Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZFADGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZFADGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 23:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbZFADGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 23:06:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48434 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbZFADGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 23:06:45 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Cc: kosaki.motohiro@jp.fujitsu.com,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
In-Reply-To: <20090601030249.GA10348@localhost>
References: <6.0.0.20.2.20090601115104.0739dac0@172.19.0.2> <20090601030249.GA10348@localhost>
Message-Id: <20090601120524.4F5A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  1 Jun 2009 12:06:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >> >I mean, you should get >300MB/s throughput with 7 disks, and you
> > >> >should seek ways to achieve that before testing out this patch :-)
> > >> 
> > >> Throughput number of storage array is very from one product to another.
> > >> On my hardware environment I think this number is valid and
> > >> my patch is effective.
> > >
> > >What's your readahead size? Is it large enough to cover the stripe width?
> > 
> > Do you mean strage's readahead size?
> 
> What's strage? I mean if your RAID's block device file is /dev/sda, then

I guess it's typo :-)
but I recommend he use sane test environment...


> 
>         blockdev --getra /dev/sda
> 
> will tell its readahead size in unit of 512 bytes.
> 
> Thanks,
> Fengguang
> 



