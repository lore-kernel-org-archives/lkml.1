Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbZDMXVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbZDMXVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZDMXUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:20:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37051
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbZDMXUv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:20:51 -0400
Date: Mon, 13 Apr 2009 16:20:42 -0700 (PDT)
Message-Id: <20090413.162042.79456870.davem@davemloft.net>
To: rjw@sisk.pl
Cc: bonbons@linux-vserver.org, romieu@fr.zoreil.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] NET/r8169: Rework suspend and resume
From: David Miller <davem@davemloft.net>
In-Reply-To: <200904052359.31629.rjw@sisk.pl>
References: <200904052040.04752.rjw@sisk.pl>
	<20090405223318.5a494e4e@neptune.home>
	<200904052359.31629.rjw@sisk.pl>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sun, 5 Apr 2009 23:59:31 +0200

> On Sunday 05 April 2009, Bruno Prémont wrote:
>> On Sun, 05 April 2009 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> > 
>> > The recent changes of the PCI PM core allow us to simplify the
>> > suspend and resume handling in a number of device drivers, since they
>> > don't need to carry out the general PCI PM operations, such as
>> > changing the power state of the device, during suspend and resume any
>> > more.
>> > 
>> > Simplify the suspend and resume callbacks of r8169 using the
>> > observation that the PCI PM core can take care of some operations
>> > carried out by the driver.
>> > 
>> > Additionally, make the shutdown callback of r8169 only put the device
>> > into a low power state if the system is going to be powered off
>> > (kexec is known to have problems with network adapters that are put
>> > into low power states on shutdown).
>> > 
>> > This patch has been tested on MSI Wind U100.
>> 
>> Tested against 2.6.29.1 on my Commell LE-365 and suspend (S3) + WoL
>> still works as expected.
>> 
>> 02:08.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
>>                      RTL-8169 Gigabit Ethernet [10ec:8169] (rev 10)
> 
> Thanks for testing!

I've applied this patch to net-next-2.6, thanks everyone.
