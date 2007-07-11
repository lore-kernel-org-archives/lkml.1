Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbXGKGen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbXGKGen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbXGKGeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:34:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33261
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754813AbXGKGeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:34:11 -0400
Date: Tue, 10 Jul 2007 23:05:06 -0700 (PDT)
Message-Id: <20070710.230506.111203158.davem@davemloft.net>
To: micah.gruber@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pekkas@netcore.fi
Subject: Re: [PATCH] [2.6.22] Remove unneeded pointer idev from
 addrconf_cleanup() in net/ipv6/addrconf.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <aaab98560707082030w6521f4e5qf17a01d83d20faf8@mail.gmail.com>
References: <aaab98560707082030w6521f4e5qf17a01d83d20faf8@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Micah Gruber" <micah.gruber@gmail.com>
Date: Mon, 9 Jul 2007 11:30:46 +0800

> This trivial patch removes the unneeded pointer idev returned from
> __in6_dev_get(), which is never used. The check for NULL can be simply
> done by if (__in6_dev_get(dev) == NULL).
> 
> Signed-off-by: Micah Gruber < micah.gruber@gmail.com>

Applied, but your patch was severely white-space damaged by your
email client, please fix this up and test that the patches you
email out can be applied by those receiving the posting in the
future.

Thanks.
