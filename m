Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbXJMKvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbXJMKvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 06:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXJMKvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 06:51:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33924 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbXJMKvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 06:51:09 -0400
Message-ID: <4710A31A.7020204@garzik.org>
Date: Sat, 13 Oct 2007 06:51:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [linux-2.6.git] IDE/ATA fighting over driver name?
References: <1192254081.29452.13.camel@Homer.simpson.net>
In-Reply-To: <1192254081.29452.13.camel@Homer.simpson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> Greetings,
> 
> Perhaps my .config is dainbramaged.  When make oldconfig asked me if I
> wanted CONFIG_PATA_PLATFORM, I said "Damned if I know, go for it".
> 
> drivers/ide/legacy/ide_platform.c:		.name = "pata_platform",
> drivers/ata/pata_platform.c:#define DRV_NAME "pata_platform"

That's a clear bug..  IDE's should be called ide_platform.

	Jeff


