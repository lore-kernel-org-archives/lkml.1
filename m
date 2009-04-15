Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZDORe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZDORe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZDOReR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:34:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50121 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752025AbZDOReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:34:16 -0400
Date: Wed, 15 Apr 2009 18:32:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: VomLehn <dvomlehn@cisco.com>
Cc: Mark Lord <lkml@rtr.ca>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090415183252.32ba7a4f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090415170617.GA14485@cuplxvomd02.corp.sa.net>
References: <Pine.LNX.4.44L0.0904151146210.3072-100000@iolanthe.rowland.org>
	<49E60219.9080103@rtr.ca>
	<20090415170617.GA14485@cuplxvomd02.corp.sa.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Saying that we were "lucky" that things worked before is no help and
> you should be aware that it ticks people off. 

No doubt those who wrote the code and never expected that timing to
reliably work will take affront at those who blame them for it not
working. Those who expected it to work and never knew it was not
guaranteed will feel likewise in reverse.

The real questions are should it be fixed and is dumping the problem on
the initrd the right answer. The concensus appears to yes and no.

The console one is less clear but if we are doing one we should probably
do both.

Alan
