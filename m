Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYAJWjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYAJWjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYAJWjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:39:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50182 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753242AbYAJWjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:39:08 -0500
Date: Thu, 10 Jan 2008 22:36:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brent Casavant <bcasavan@sgi.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       penguin-kernel@i-love.sakura.ne.jp, netdev@vger.kernel.org,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: AF_UNIX MSG_PEEK bug?
Message-ID: <20080110223623.3a925f57@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.BSF.1.00.0801101554100.52456@pkunk.americas.sgi.com>
References: <E1JCkrp-0000vX-00@gondolin.me.apana.org.au>
	<alpine.BSF.1.00.0801092031290.35527@pkunk.americas.sgi.com>
	<alpine.BSF.1.00.0801101554100.52456@pkunk.americas.sgi.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> and the parallel portions/comments in unix_dgram_recvmsg(),
> it looks like there's been a lot of uncertainty as to how
> file descriptor passing should be handled durning MSG_PEEK
> operations.  To quote:

The specs basically don't answer the question. What is critical is that
the behaviour does not change compared with older Linux releases.

