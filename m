Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbXEUHry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbXEUHry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbXEUHrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:47:47 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:49253 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXEUHrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:47:46 -0400
Message-ID: <46514E94.9030808@drzeus.cx>
Date: Mon, 21 May 2007 09:47:32 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Race free attributes in sysfs
References: <46502A8B.70803@drzeus.cx> <200705202312.19191.dtor@insightbb.com>
In-Reply-To: <200705202312.19191.dtor@insightbb.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> 1. dev->uevent_suppress = 1;
> 2. device_register(dev);
> 3. device_create_file(dev, ...);
> 4. dev->uevent_suppress = 0;
> 5. kobject_uevent(&dev->kobj, KOBJ_ADD);
>
>   

Simple enough. Thanks :)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

