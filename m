Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZCTNJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZCTNJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZCTNJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:09:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45548 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbZCTNJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:09:07 -0400
Date: Fri, 20 Mar 2009 10:08:39 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] blktrace: avoid accessing NULL bdev->bd_disk
Message-ID: <20090320130839.GM30407@ghostprotocols.net>
References: <49C2F599.3060306@cn.fujitsu.com> <49C2F63C.2090107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2F63C.2090107@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 20, 2009 at 09:49:48AM +0800, Li Zefan escreveu:
> bdev->bd_disk can be NULL, if the block device is not opened.
> 
> Try this against an unmounted partition, and you'll see NULL dereference:
>   # echo 1 > /sys/block/sda/sda5/enable
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I guess this can be discounted on my block layer newbeeness 8)

But as an extra check in non hot-paths are usually a good thing...

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
