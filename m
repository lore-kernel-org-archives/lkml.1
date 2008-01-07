Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYAGRZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYAGRZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758166AbYAGRZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:25:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56624 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757474AbYAGRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:25:39 -0500
Date: Mon, 7 Jan 2008 12:25:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Greg KH <gregkh@suse.de>, <James.Bottomley@hansenpartnership.com>,
       <dbrownell@users.sourceforge.net>,
       Dave Young <hidave.darkstar@gmail.com>, <linux-scsi@vger.kernel.org>,
       <a.zummo@towertech.it>, <peterz@infradead.org>, <cbou@mail.ru>,
       <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>,
       <krh@redhat.com>, <rtc-linux@googlegroups.com>,
       <spi-devel-general@lists.sourceforge.net>,
       <linux1394-devel@lists.sourceforge.net>, <dwmw2@infradead.org>,
       <davem@davemloft.net>, <jarkao2@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
In-Reply-To: <47825DC1.3090102@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.44L0.0801071224200.2748-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, Stefan Richter wrote:

> Semi off-topic:  What about struct device.sem?  Is there any chance to
> rip this out of the driver core and let drivers serialize everything?  I
> suppose not...

There isn't.  The core uses that lock.

Alan Stern

