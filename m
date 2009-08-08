Return-Path: <linux-kernel-owner+w=401wt.eu-S934154AbZHHMxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154AbZHHMxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 08:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934137AbZHHMxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 08:53:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40024 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934133AbZHHMxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 08:53:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
Date: Sat, 8 Aug 2009 14:53:34 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <1248404514.2670.107.camel@rzhang-dt> <200908080222.03172.rjw@sisk.pl> <20090808005922.110A3526EA5@mailhub.coreip.homeip.net>
In-Reply-To: <20090808005922.110A3526EA5@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908081453.34718.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 August 2009, Dmitry Torokhov wrote:
> On Friday 07 August 2009 17:22:03 Rafael J. Wysocki wrote:
> > +       device_enable_async_pm(&i8042_platform_device->dev, true);
> > +
> 
> Please don't do that, at least not right now. i8042 being the fine
> piece of {soft,hard}ware as it is will not like when you start banging
> on all its ports at the same time.

Don't worry, this patch is only a prototype.

Best,
Rafael
