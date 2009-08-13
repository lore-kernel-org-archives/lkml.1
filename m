Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbZHMRwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbZHMRwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbZHMRwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:52:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35667 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbZHMRwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:52:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
Date: Thu, 13 Aug 2009 19:53:10 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "dtor@mail.ru" <dtor@mail.ru>
References: <Pine.LNX.4.44L0.0908131028370.2940-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908131028370.2940-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908131953.10819.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Alan Stern wrote:
> On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:
> 
> > On a second thought, though, would it be a good idea to add
> > pm_runtime_get_noresume() / pm_runtime_put_sync() around the bus_for_each_drv()
> > in device_attach()?  That would prevent us from resuming-suspending the device
> > on each failing probe.
> 
> Good idea.  But don't remove the existing code in driver_probe_device.

Sure.

OK, I'll make this change and post rev. 16 shortly.

Thanks,
Rafael
