Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbXLWPZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbXLWPZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXLWPZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 10:25:29 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:47522 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbXLWPZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 10:25:28 -0500
Date: Sun, 23 Dec 2007 16:25:27 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Boldi <a1426z@gawab.com>
cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] USB Kconfig: Reorganize USB Kconfig Menu
In-Reply-To: <200712231615.21003.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0712231623060.21470@fbirervta.pbzchgretzou.qr>
References: <200712231449.00862.a1426z@gawab.com>
 <Pine.LNX.4.64.0712231331270.21470@fbirervta.pbzchgretzou.qr>
 <200712231615.21003.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 23 2007 16:15, Al Boldi wrote:
>> >-menuconfig USB_SUPPORT
>> >-	bool "USB support"
>> >+config USB_SUPPORT
>> >+	bool
>> > 	depends on HAS_IOMEM
>> > 	default y
>> > 	---help---
>>
>> With this patch, is USB_SUPPORT still needed? It is not visible (anymore),
>> always is y and no other options select/depend on it (according to
>> Kconfig '/' function).
>
>Well, I left it in, because of defconfig dependencies, and HAS_IOMEM is 
>needed for a few archs.
>
But I do not see any config option that depends on USB_SUPPORT.
