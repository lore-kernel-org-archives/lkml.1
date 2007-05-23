Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbXEWCoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbXEWCoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 22:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbXEWCn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 22:43:56 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:47294 "EHLO
	asav06.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbXEWCn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 22:43:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusRAHFHU0ZKhRO4W2dsb2JhbACHQYhGHQ0FEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: Race free attributes in sysfs
Date: Tue, 22 May 2007 22:43:55 -0400
User-Agent: KMail/1.9.3
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <46502A8B.70803@drzeus.cx> <200705202312.19191.dtor@insightbb.com> <46535F7F.1040504@rtr.ca>
In-Reply-To: <46535F7F.1040504@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705222243.56007.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2007 17:24, Mark Lord wrote:
> Dmitry Torokhov wrote:
> > 1. dev->uevent_suppress = 1;
> > 2. device_register(dev);
> > 3. device_create_file(dev, ...);
> > 4. dev->uevent_suppress = 0;
> > 5. kobject_uevent(&dev->kobj, KOBJ_ADD);
> 
> I don't see how that prevents an already-running udevd
> from seeing the partially filled in /sys/ entry,
> if it were.. say.. already doing a /sys scan,
> or even just during initial startup.

I tought udev relies on uevents and does not hunt through sysfs on
its own...

-- 
Dmitry
