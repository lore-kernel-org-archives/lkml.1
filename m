Return-Path: <linux-kernel-owner+w=401wt.eu-S1750957AbXCETpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957AbXCETpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXCETpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:45:19 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:33209 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbXCETpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:45:18 -0500
Subject: Re: [DOC] The documentation for HID Simple Driver Interface 0.5.0
From: Marcel Holtmann <marcel@holtmann.org>
To: Li Yu <raise.sail@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Greg Kroah Hartman <greg@kroah.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Vincent Legoll <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harold Sargeant <harold-sargeant@ntlworld.com>,
       liyu <liyu@ccoss.com.cn>
In-Reply-To: <200703051532096508636@gmail.com>
References: <200703051532096508636@gmail.com>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 21:44:31 +0100
Message-Id: <1173127471.6638.96.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

> ==================================
> HID device simple driver interface
> ==================================

actually, I don't think we need a simple driver interface. We need a HID
driver interface in general. For example that you can register a driver
for one or multiple report ID and then it handles input and output for
these report IDs. This also means that the current keyboard and mouse
input devices will become a HID driver.

In addition to the kernel HID driver we might also when have a new
hidraw (or modified hiddev) interface that allows to handle specific
report ID from a userspace application. Especially when it comes to LED
displays or UPS systems.

Regards

Marcel


