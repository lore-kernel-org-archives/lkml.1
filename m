Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYG3HEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYG3HEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYG3HEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:04:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43365
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbYG3HEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:04:33 -0400
Date: Wed, 30 Jul 2008 00:04:29 -0700 (PDT)
Message-Id: <20080730.000429.63188454.davem@davemloft.net>
To: steven@springl.ukfsn.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel oops in 2.6.27-rc1 qdisc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200807291923.22803.steven@springl.ukfsn.org>
References: <200807291923.22803.steven@springl.ukfsn.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Jan Springl <steven@springl.ukfsn.org>
Date: Tue, 29 Jul 2008 19:23:22 +0100

> Issuing the following command causes a kernel oops:
> 	tc qdisc add dev eth0 handle ffff: ingress
> 
> The problem is recreatable.
> The kernel is 2.6.27-rc1.
> I am using Debian etch.
> 
> The oops is attached.

Thanks for the report, I'll fix this.

Please CC: netdev on networking bug reports in the future, thanks.
