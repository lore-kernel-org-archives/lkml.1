Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZDEV7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZDEV7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 17:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZDEV7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 17:59:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41621 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbZDEV7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 17:59:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH] NET/r8169: Rework suspend and resume
Date: Sun, 5 Apr 2009 23:59:31 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Francois Romieu <romieu@fr.zoreil.com>, NetDev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200904052040.04752.rjw@sisk.pl> <20090405223318.5a494e4e@neptune.home>
In-Reply-To: <20090405223318.5a494e4e@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904052359.31629.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009, Bruno Prémont wrote:
> On Sun, 05 April 2009 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The recent changes of the PCI PM core allow us to simplify the
> > suspend and resume handling in a number of device drivers, since they
> > don't need to carry out the general PCI PM operations, such as
> > changing the power state of the device, during suspend and resume any
> > more.
> > 
> > Simplify the suspend and resume callbacks of r8169 using the
> > observation that the PCI PM core can take care of some operations
> > carried out by the driver.
> > 
> > Additionally, make the shutdown callback of r8169 only put the device
> > into a low power state if the system is going to be powered off
> > (kexec is known to have problems with network adapters that are put
> > into low power states on shutdown).
> > 
> > This patch has been tested on MSI Wind U100.
> 
> Tested against 2.6.29.1 on my Commell LE-365 and suspend (S3) + WoL
> still works as expected.
> 
> 02:08.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
>                      RTL-8169 Gigabit Ethernet [10ec:8169] (rev 10)

Thanks for testing!

Best,
Rafael
