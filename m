Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbYDCWAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbYDCWAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 18:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbYDCWAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 18:00:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47177
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755663AbYDCWAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 18:00:21 -0400
Date: Thu, 03 Apr 2008 15:00:21 -0700 (PDT)
Message-Id: <20080403.150021.230322261.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: chas@cmf.nrl.navy.mil, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/atm/ambassador.c: stop inlining largish static
 functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804010314.58117.vda.linux@googlemail.com>
References: <200804010314.58117.vda.linux@googlemail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 1 Apr 2008 03:14:58 +0200

> This patch removes "inline" from these static functions
> (regardless of number of callsites - gcc nowadays auto-inlines
> statics with one callsite).
> 
> Size difference for 32bit x86:
>    text    data     bss     dec     hex filename
>   10209    8488       4   18701    490d linux-2.6-ALLYES/drivers/atm/ambassador.o
>    9462    8488       4   17954    4622 linux-2.6.inline-ALLYES/drivers/atm/ambassador.o
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

I've applied this to net-2.6.26, if John doesn't like it we
can fix it or revert.
