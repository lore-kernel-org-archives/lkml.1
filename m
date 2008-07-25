Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYGYUMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYGYUMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYGYUMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:12:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47223
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbYGYUMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:12:40 -0400
Date: Fri, 25 Jul 2008 13:12:39 -0700 (PDT)
Message-Id: <20080725.131239.163876268.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: pupilla@hotmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.26: [<c0133cc1>] __alloc_pages_internal+0x331/0x343
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080725141953.GA19418@gondor.apana.org.au>
References: <BAY103-DAV74E605DFBE7CC22EEA732B2870@phx.gbl>
	<E1KMO85-00052z-00@gondolin.me.apana.org.au>
	<20080725141953.GA19418@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 25 Jul 2008 22:19:53 +0800

> Actually even more likely, someone has sent you a huge packet
> which triggered this (> 32K if I remember your trace correctly).

I wonder if there are IPSEC implementations out there
that apply IPSEC before doing the MSS/MTU checks and
sizing, for local socket generated frames :-)
