Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbZDEUdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbZDEUdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 16:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZDEUdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 16:33:25 -0400
Received: from ppp-110-39.adsl.restena.lu ([158.64.110.39]:39186 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbZDEUdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 16:33:24 -0400
Date: Sun, 5 Apr 2009 22:33:18 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Francois Romieu <romieu@fr.zoreil.com>, NetDev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] NET/r8169: Rework suspend and resume
Message-ID: <20090405223318.5a494e4e@neptune.home>
In-Reply-To: <200904052040.04752.rjw@sisk.pl>
References: <200904052040.04752.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 April 2009 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The recent changes of the PCI PM core allow us to simplify the
> suspend and resume handling in a number of device drivers, since they
> don't need to carry out the general PCI PM operations, such as
> changing the power state of the device, during suspend and resume any
> more.
> 
> Simplify the suspend and resume callbacks of r8169 using the
> observation that the PCI PM core can take care of some operations
> carried out by the driver.
> 
> Additionally, make the shutdown callback of r8169 only put the device
> into a low power state if the system is going to be powered off
> (kexec is known to have problems with network adapters that are put
> into low power states on shutdown).
> 
> This patch has been tested on MSI Wind U100.

Tested against 2.6.29.1 on my Commell LE-365 and suspend (S3) + WoL
still works as expected.

02:08.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
                     RTL-8169 Gigabit Ethernet [10ec:8169] (rev 10)

Bruno
