Return-Path: <linux-kernel-owner+w=401wt.eu-S936114AbXGMPZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936114AbXGMPZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761292AbXGMPZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:25:32 -0400
Received: from [81.2.110.250] ([81.2.110.250]:50718 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759787AbXGMPZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:25:32 -0400
Date: Fri, 13 Jul 2007 16:32:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Driver question: multiple instances of same char device
Message-ID: <20070713163201.1cb6165f@the-village.bc.nu>
In-Reply-To: <1184072796.31808.30.camel@microwave.infinitevideocorporation.com>
References: <1184072796.31808.30.camel@microwave.infinitevideocorporation.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 09:06:36 -0400
Jon Dufresne <jon.dufresne@infinitevideocorporation.com> wrote:

> I am relatively new to linux device development. And want to understand
> Linux conventions.
> 
> Suppose I have a PCI card that is represented in the system by a
> character device.
> 
> If I have two of those PCI cards in the system when the driver module
> loads, is it convention to have two different major numbers, or have one
> major number and two different minor numbers?

Usually one major and two minor, although sysfs and udev deals with much
of it now
