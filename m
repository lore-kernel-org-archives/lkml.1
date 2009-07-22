Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZGVSYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZGVSYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZGVSYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:24:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60302
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386AbZGVSYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:24:50 -0400
Date: Wed, 22 Jul 2009 11:24:56 -0700 (PDT)
Message-Id: <20090722.112456.150910386.davem@davemloft.net>
To: avictor.za@gmail.com
Cc: u.kleine-koenig@pengutronix.de, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, netdev@vger.kernel.org,
       paulius.zaleckas@teltonika.lt, marc.pignat@hevs.ch, linux@maxim.org.za,
       12o3l@tiscali.nl, akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: [PATCH] register at91_ether using platform_driver_probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <cd73a99e0907221046k5e435fd3m3cb1fd006c0385a7@mail.gmail.com>
References: <200907111527.46441.david-b@pacbell.net>
	<1248207099-14583-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<cd73a99e0907221046k5e435fd3m3cb1fd006c0385a7@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Victor <avictor.za@gmail.com>
Date: Wed, 22 Jul 2009 19:46:24 +0200

> hi,
> 
>> at91ether_probe lives in .init.text, so using platform_driver_register
>> to register it is wrong because binding a device after the init memory
>> is discarded (e.g. via sysfs) results in an oops.
>>
>> As requested by David Brownell platform_driver_probe is used instead of
>> moving the probe function to .devinit.text as proposed initially.
>> This saves some memory, but devices registered after the driver is
>> probed are not bound (probably there are none) and binding via sysfs
>> isn't possible.
> 
> 
> Acked-by: Andrew Victor <linux@maxim.org.za>

Applied, thanks everyone.
