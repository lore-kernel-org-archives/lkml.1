Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZKFI01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZKFI01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZKFI00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:26:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44780
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753750AbZKFI00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:26:26 -0500
Date: Fri, 06 Nov 2009 00:26:51 -0800 (PST)
Message-Id: <20091106.002651.21006753.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       kristoffer@gaisler.com
Subject: Re: linux-next: sparc tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091106.001930.121210402.davem@davemloft.net>
References: <20091106180248.7a6aa9ba.sfr@canb.auug.org.au>
	<20091106.001930.121210402.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 06 Nov 2009 00:19:30 -0800 (PST)

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 6 Nov 2009 18:02:48 +1100
> 
>> Caused by commit d4ac42a582e46d7f86f0acb4253a310423c72c4c ("sparc:
>> Support for GRLIB APBUART serial port") (yes again :-)).  I have applied
>> my patch to make it only build on SPARC again ...
>> 
>> (Including linux/of_platform.h - where struct of_platform_driver,
>> of_register_driver() and of_platform_bus_type are declared - would be a
>> good start ...  and the code should probably be using
>> of_register_platform_driver() instead of of_register_driver() in any
>> case.)
> 
> Sorry, sparc is getting those headers indirectly.
> 
> I'll fix this up.

Stephen, can you let me know if this takes care of everything?

I also noticed that the of_driver was not being unregistered on
module unload.

apbuart: Fix build and missing driver unregister.

linux/of_platform.h needs to be included

OF driver needs to be unregistered

Signed-off-by: David S. Miller <davem@davemloft.net>
