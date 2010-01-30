Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711Ab0A3M63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab0A3M63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 07:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884Ab0A3M63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 07:58:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47563 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355Ab0A3M62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 07:58:28 -0500
Date: Sat, 30 Jan 2010 12:59:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: vedran.furac@gmail.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-ID: <20100130125917.600beb51@lxorguk.ukuu.org.uk>
In-Reply-To: <4B64272D.8020509@gmail.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126151202.75bd9347.akpm@linux-foundation.org>
	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126161952.ee267d1c.akpm@linux-foundation.org>
	<20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100128001636.2026a6bc@lxorguk.ukuu.org.uk>
	<4B622AEE.3080906@gmail.com>
	<20100129003547.521a1da9@lxorguk.ukuu.org.uk>
	<4B62327F.3010208@gmail.com>
	<20100129110321.564cb866@lxorguk.ukuu.org.uk>
	<4B64272D.8020509@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So how about you go and have a complain at the people who are causing
> > your problem, rather than the kernel.
> 
> That would pass completely unnoticed and ignored as long as overcommit
> is enabled by default.

Defaults are set by the distributions. So you are still complaining to
the wrong people.

> So, if you don't want to change the OOM algorithm why not fixing this
> bug then? And after that change the proc(5) manpage entry for
> /proc/sys/vm/overcommit_memory into something like:
> 
> 0: heuristic overcommit (enable this if you have memory problems with
>                           some buggy software)
> 1: always overcommit, never check
> 2: always check, never overcommit (this is the default)

Because there are a lot of systems where heuristic overcommit makes
sense ?

Alan
