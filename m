Return-Path: <linux-kernel-owner+w=401wt.eu-S937824AbXGSJEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937824AbXGSJEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764007AbXGSJEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:04:36 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:49018 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763937AbXGSJEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:04:35 -0400
Date: Thu, 19 Jul 2007 18:05:18 +0900 (JST)
Message-Id: <20070719.180518.79100322.yoshfuji@linux-ipv6.org>
To: jens.axboe@oracle.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com, johnpol@2ka.mipt.ru, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH][RFC] network splice receive v3
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20070711091927.GQ4587@kernel.dk>
References: <20070711091927.GQ4587@kernel.dk>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

In article <20070711091927.GQ4587@kernel.dk> (at Wed, 11 Jul 2007 11:19:27 +0200), Jens Axboe <jens.axboe@oracle.com> says:

> @@ -835,6 +835,7 @@ const struct proto_ops inet_stream_ops = {
>  	.recvmsg	   = sock_common_recvmsg,
>  	.mmap		   = sock_no_mmap,
>  	.sendpage	   = tcp_sendpage,
> +	.splice_read	   = tcp_splice_read,
>  #ifdef CONFIG_COMPAT
>  	.compat_setsockopt = compat_sock_common_setsockopt,
>  	.compat_getsockopt = compat_sock_common_getsockopt,

Please add similar bits in net/ipv6/af_inet6.c
unless there are any dependency on IPv4.
(And if there are, it is not good.)

--yoshfuji
