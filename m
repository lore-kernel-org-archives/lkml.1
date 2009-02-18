Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbZBRBau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbZBRBau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbZBRB2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:28:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49810
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756230AbZBRB2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:28:05 -0500
Date: Tue, 17 Feb 2009 17:27:49 -0800 (PST)
Message-Id: <20090217.172749.224722175.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/43] drivers/net/hamradio: fix warning: format not a
 string literal and no ...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214213243.24377.94508.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214213243.24377.94508.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:33:21 +0100

> Impact: Use 'static const char[]' instead of 'static char[]' and while
> being at it fix an issue in 'mkiss_init_driver', where in case of an
> error the status code was not passed to printk.
> 
> Fix this warnings:
>   drivers/net/hamradio/6pack.c: In function 'sixpack_init_driver':
>   drivers/net/hamradio/6pack.c:802: warning: format not a string literal and no format arguments
>   drivers/net/hamradio/bpqether.c: In function 'bpq_init_driver':
>   drivers/net/hamradio/bpqether.c:609: warning: format not a string literal and no format arguments
>   drivers/net/hamradio/mkiss.c: In function 'mkiss_init_driver':
>   drivers/net/hamradio/mkiss.c:988: warning: format not a string literal and no format arguments
>   drivers/net/hamradio/mkiss.c:991: warning: format not a string literal and no format arguments
>   drivers/net/hamradio/scc.c: In function 'scc_init_driver':
>   drivers/net/hamradio/scc.c:2109: warning: format not a string literal and no format arguments
>   drivers/net/hamradio/yam.c: In function 'yam_init_driver':
>   drivers/net/hamradio/yam.c:1094: warning: format not a string literal and no format arguments
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
