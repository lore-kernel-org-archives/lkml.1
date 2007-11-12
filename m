Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbXKLW0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbXKLW0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbXKLW0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:26:05 -0500
Received: from mx10.go2.pl ([193.17.41.74]:40191 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755575AbXKLW0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:26:04 -0500
Message-ID: <4738D398.8050402@o2.pl>
Date: Mon, 12 Nov 2007 23:28:40 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: top lies ?
References: <Pine.BSO.4.63.0711121843170.3123@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0711121843170.3123@rudy.mif.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz K³oczko wrote, On 11/12/2007 06:57 PM:

> Some data showed by top command looks like completly trashed.
> Fragment from top output:
> 
> Mem:   2075784k total,  2053352k used,    22432k free,    19260k buffers
> Swap:  2096472k total,      136k used,  2096336k free,  1335080k cached
> 
>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  SWAP nFLT WCHAN     COMMAND
> 14515 mysql     20   0 1837m 563m 4132 S   39 27.8  27:14.20 1.2g   18 -         mysqld
> 
> How it is possible that swap ussage is 136k and swapped out portion of (in 
> this case) mysqld process is 1.2g ?

It seems this bigger SWAP is virtual (not necessarily used yet), something
similar like here:

>From man ps:

 
"size      SZ     approximate amount of swap space that would be required if the process were to dirty
                  all writable pages and then be swapped out. This number is very rough!"
 

Regards,
Jarek P.
