Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbXKFHk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbXKFHk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 02:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbXKFHkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 02:40:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbXKFHks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 02:40:48 -0500
Date: Mon, 5 Nov 2007 23:40:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Message-Id: <20071105234017.fcc10791.akpm@linux-foundation.org>
In-Reply-To: <300725321593711206@pripojeni.net>
References: <300725321593711206@pripojeni.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Aug 2007 07:09:02 -0700 Jiri Slaby <jirislaby@gmail.com> wrote:

> stk11xx, add a new webcam driver
> 
> Adds support for stk1125, stk1135 and stkdcnew webcam built-in some
> notebooks.

Seem that something in git-dvb (or mainline) broke this driver:

drivers/media/video/stk11xx-core.c: In function 'show_contrast':
drivers/media/video/stk11xx-core.c:707: warning: initialization from incompatible pointer type
drivers/media/video/stk11xx-core.c: In function 'show_whitebalance':
drivers/media/video/stk11xx-core.c:714: warning: initialization from incompatible pointer type
drivers/media/video/stk11xx-core.c: In function 'stk11xx_create_sysfs_file':
drivers/media/video/stk11xx-core.c:727: warning: passing argument 1 of 'class_device_create_file' from incompatible pointer type
drivers/media/video/stk11xx-core.c: In function 'stk11xx_usb_disconnect':
drivers/media/video/stk11xx-core.c:851: warning: passing argument 1 of 'class_device_remove_file' from incompatible pointer type
drivers/media/video/stk11xx-core.c:853: warning: passing argument 1 of 'class_device_remove_file' from incompatible pointer type

Also, please ask the v4l/dvb guys to look at this driver - there's not a lot
of point in sending it just to me.
