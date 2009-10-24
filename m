Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbZJXNpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbZJXNpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 09:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZJXNpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 09:45:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42360
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbZJXNpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 09:45:40 -0400
Date: Sat, 24 Oct 2009 06:46:03 -0700 (PDT)
Message-Id: <20091024.064603.249036129.davem@davemloft.net>
To: william.allen.simpson@gmail.com
Cc: huananhu@huawei.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       zihan@huawei.com, greg@kroah.com, haegar@sdinet.de
Subject: Re: PATCH 23/10]Optimize the upload speed for PPP connection.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AE19780.3020507@gmail.com>
References: <fae097f21b27.1b27fae097f2@huawei.com>
	<4AE19780.3020507@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Allen Simpson <william.allen.simpson@gmail.com>
Date: Fri, 23 Oct 2009 07:46:08 -0400

> Concur.  I'd go further than that, my code usually made room for at
> least
> a full MTU (MRU) with HDLC escaping.  To minimize context switches,
> that
> should be 3014 ((1500 MRU + 2 FCS + 4 header) * 2 escapes + 2 flags).
> 
> Even in the old days, when memory was tight, context switches and
> interrupt
> time were more expensive, too.  PPP is supposed to scale to OC-192.

Actually I'd like to see ->obuf allocated externally and then
make it simply PAGE_SIZE.
