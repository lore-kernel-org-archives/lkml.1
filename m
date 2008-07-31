Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYGaK5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYGaK5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYGaK5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:57:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54805
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbYGaK5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:57:08 -0400
Date: Thu, 31 Jul 2008 03:57:08 -0700 (PDT)
Message-Id: <20080731.035708.149435626.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: bhutchings@solarflare.com, thomas.petazzoni@free-electrons.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, mpm@selenic.com, jgarzik@pobox.com,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 3/4] Configure out ethtool support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217501664.3454.151.camel@pmac.infradead.org>
References: <20080731104004.GN10471@solarflare.com>
	<20080731.034904.190066778.davem@davemloft.net>
	<1217501664.3454.151.camel@pmac.infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 31 Jul 2008 11:54:24 +0100

> Other potential approaches include not enabling LRO by default if 
> !CONFIG_ETHTOOL. Or having the driver(s) which _do_ enable LRO by
> default 'select ETHTOOL'.

It is possible for us to generically enable LRO for every device,
since it is a software algorithm.  And likely we will do something
like this in the not too distant future.
