Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbZHRJzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbZHRJzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 05:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbZHRJzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 05:55:18 -0400
Received: from senator.holtmann.net ([87.106.208.187]:59734 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbZHRJzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 05:55:17 -0400
Subject: Re: [PATCH 3/3] Drop platform sysfs support
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Mario Limonciello <mario_limonciello@dell.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, cezary.jackiewicz@gmail.com
In-Reply-To: <9b2b86520908180143t4b25c1f7hd78cd4b4333c4ab4@mail.gmail.com>
References: <4A89E76B.5070204@dell.com>
	 <9b2b86520908180143t4b25c1f7hd78cd4b4333c4ab4@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 02:54:45 -0700
Message-Id: <1250589285.5150.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> > With rfkill support being added, the platform support is no longer
> > necessary.  Standard rfkill interfaces can be used to administer the box
> > now.
> > --
> > Mario Limonciello
> > *Dell | Linux Engineering*
> > mario_limonciello@dell.com
> >
> 
> -static struct platform_device *compal_device;
> 
> I don't think this is the right way to go.  I don't object to removing
> the sysfs attributes, but the platform device can still be useful as a
> parent device to the rfkill and backlight devices.  (See my earlier
> comment on the use of rfkill_allocate()).
> 
> In practice I suspect it makes no difference that the rfkill and
> backlight devices are exported as virtual devices with no physical
> parent.  I just don't think it's "right" :-).

it actually does make a difference for hardware detection. We wanna have
them hanging of the compal platform device.

Regards

Marcel


