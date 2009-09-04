Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZIDEfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZIDEfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 00:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZIDEff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 00:35:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39189
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbZIDEfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 00:35:33 -0400
Date: Thu, 03 Sep 2009 21:35:48 -0700 (PDT)
Message-Id: <20090903.213548.46609322.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, netdev@vger.kernel.org
Subject: Re: linux-next: net tree build warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090904143439.c44f61ee.sfr@canb.auug.org.au>
References: <20090904143439.c44f61ee.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 4 Sep 2009 14:34:39 +1000

> Today's linux-next build (x86_64 allmodconfig gcc-4.4.0) produced thes
> warnings:
> 
> drivers/net/wan/dlci.c: In function 'dlci_transmit':
> drivers/net/wan/dlci.c:205: warning: enumeration value 'NETDEV_TX_LOCKED' not handled in switch
> drivers/net/wan/dlci.c:215: warning: case value '2' not in enumerated type 'netdev_tx_t'
> 
> Introduced by commit d71a674922e7519edb477ecb585e7d29d69c7aa7 ("wan:
> convert drivers to netdev_tx_t").

I know about it, this code sucks and it's not easy to quelch that
one trivially.
