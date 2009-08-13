Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbZHMOax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbZHMOax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZHMOaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:30:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45397 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752446AbZHMOav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:30:51 -0400
Date: Thu, 13 Aug 2009 10:30:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "dtor@mail.ru" <dtor@mail.ru>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
In-Reply-To: <200908122318.12145.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908131028370.2940-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, Rafael J. Wysocki wrote:

> On a second thought, though, would it be a good idea to add
> pm_runtime_get_noresume() / pm_runtime_put_sync() around the bus_for_each_drv()
> in device_attach()?  That would prevent us from resuming-suspending the device
> on each failing probe.

Good idea.  But don't remove the existing code in driver_probe_device.

Alan Stern

