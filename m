Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbYHUK0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbYHUK0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYHUK0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:26:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51321
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbYHUK0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:26:34 -0400
Date: Thu, 21 Aug 2008 03:26:34 -0700 (PDT)
Message-Id: <20080821.032634.14561915.davem@davemloft.net>
To: kosaki.motohiro@jp.fujitsu.com
Cc: peterz@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       cl@linux-foundation.org, tokunaga.keiich@jp.fujitsu.com, travis@sgi.com
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of
 CPUs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080821191330.22B2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080821183648.22AF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080821.030932.75221247.davem@davemloft.net>
	<20080821191330.22B2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 21 Aug 2008 19:13:55 +0900

> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Date: Thu, 21 Aug 2008 19:04:28 +0900
> > 
> > > but I worry about it works on sparc64...
> > 
> > It should.
> 
> Could you please confirm it?

davem@sunset:~/src/GIT/net-2.6$ patch -p1 <diff
patching file mm/quicklist.c
davem@sunset:~/src/GIT/net-2.6$ make mm/quicklist.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      mm/quicklist.o
davem@sunset:~/src/GIT/net-2.6$ 
