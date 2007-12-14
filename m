Return-Path: <linux-kernel-owner+w=401wt.eu-S1764666AbXLNJgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764666AbXLNJgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760073AbXLNJfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:35:53 -0500
Received: from [222.73.24.84] ([222.73.24.84]:50097 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757285AbXLNJfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:35:52 -0500
Message-ID: <47624DC5.2010803@cn.fujitsu.com>
Date: Fri, 14 Dec 2007 17:32:53 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: fpavlic@de.ibm.com, jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] s390/net/qeth_main.c: Fix use of skb after netif_rx
References: <Pine.LNX.4.64.0712141025470.29947@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0712141025470.29947@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall said the following on 2007-12-14 17:28:
> From: Julia Lawall <julia@diku.dk>
> 
> Recently, Wang Chen submitted a patch
> (d30f53aeb31d453a5230f526bea592af07944564) to move a call to netif_rx(skb)
> after a subsequent reference to skb, because netif_rx may call kfree_skb on
> its argument.  The same problem occurs in some other drivers as well.
> 

It looks good to me.

