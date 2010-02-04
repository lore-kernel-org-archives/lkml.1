Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab0BDCTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:19:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52331
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756062Ab0BDCTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:19:17 -0500
Date: Wed, 03 Feb 2010 18:19:31 -0800 (PST)
Message-Id: <20100203.181931.39810642.davem@davemloft.net>
To: johny@asimco.com.cn
Cc: kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org, jmorris@namei.org,
       kaber@coreworks.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27.7-9-pae #7 SMP 1/1] networking tcp: Writing tcp
 socket be atomic
From: David Miller <davem@davemloft.net>
In-Reply-To: <DB4F116661E3B0428456BB7E379EF4BB3C5F57@MX.asimcotech.com>
References: <474C17045AA24E3F8519EE76BAB47439@JOHNYE1>
	<20100203.085249.98326242.davem@davemloft.net>
	<DB4F116661E3B0428456BB7E379EF4BB3C5F57@MX.asimcotech.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John Ye" <johny@asimco.com.cn>
Date: Thu, 4 Feb 2010 10:03:44 +0800

> The option TCP_ATOMIC is not a must.  We can make atomic be default
> if the data size is less than a fixed size, just the same as pipe.
> For example, if the data size is less than 512, we don't split the
> data so it goes atomically.

This completely ignores the core issue.

And that is, for the second time, that the application is where such
atomicity guarentees should be implemented.

And because of that any implementation of your kernel changes are
inappropriate, TCP_ATOMIC socket option or not.
