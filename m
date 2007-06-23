Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbXFWFZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbXFWFZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 01:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbXFWFZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 01:25:45 -0400
Received: from [212.12.190.198] ([212.12.190.198]:32906 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751397AbXFWFZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 01:25:44 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Harddisk speed drop of 100 MB/s
Date: Sat, 23 Jun 2007 08:26:01 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706230826.01872.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Wood wrote:
> Just one kernel version? The problem here is in every
> kernel revision after 551c012d7eea3dc5ec063c7ff9c718d39e77634f
>
> 2.6.20-rc2,rc3,rc4,rc5,rc6,rc7 ... 2.6.20 ... 2.6.21 ... 2.6.22-rc5
>
> noop:
>  Timing buffered disk reads:  254 MB in  3.00 seconds =  84.66 MB/sec
>
> anticipatory:
>  Timing buffered disk reads:  252 MB in  3.02 seconds =  83.43 MB/sec
>
> deadline:
>  Timing buffered disk reads:  258 MB in  3.02 seconds =  85.41 MB/sec
>
> cfq:
>  Timing buffered disk reads:  194 MB in  3.03 seconds =  64.06 MB/sec
>
> The normal value is cfq. So, all other schedulars are somewhat faster,
> but still far from the correct 165 MB/s.

You may want to play with /sys/block/*/queue/max_sectors_kb and 
read_ahead_kb.  On my system, setting them to 192 gives best performance, 
but cfq is always slower.


Thanks!

--
Al

