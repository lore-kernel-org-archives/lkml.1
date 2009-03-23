Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZCWIG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZCWIG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZCWIFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:05:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60253
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756309AbZCWIFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:05:54 -0400
Date: Mon, 23 Mar 2009 01:05:41 -0700 (PDT)
Message-Id: <20090323.010541.94308473.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: mpm@selenic.com, marcin.slusarz@gmail.com, netdev@vger.kernel.org,
       k-keiichi@bx.jp.nec.com, stable@kernel.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netconsole: fix BUG during net device "upping"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090323080455.GA4976@ff.dom.local>
References: <20090322.212107.55546529.davem@davemloft.net>
	<20090323080455.GA4976@ff.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Mon, 23 Mar 2009 08:04:55 +0000

> What is the rationale of this decision? printk is a basic tool,
> especially designed to work in as many places as possible, and
> netconsole is rather something secondary (sorry Matt)?!

And this basic tool cannot work from the drivers ->open() method.
