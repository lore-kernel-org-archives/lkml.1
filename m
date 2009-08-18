Return-Path: <linux-kernel-owner+w=401wt.eu-S1751347AbZHRVqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbZHRVqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZHRVqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:46:09 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35583 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZHRVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:46:08 -0400
Subject: Re: [PATCH 3/3] Drop platform sysfs support
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Mario Limonciello <mario_limonciello@dell.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, cezary.jackiewicz@gmail.com
In-Reply-To: <9b2b86520908180623i4e7ce5cv9a4cd6b1704a0e5f@mail.gmail.com>
References: <4A89E76B.5070204@dell.com>
	 <9b2b86520908180143t4b25c1f7hd78cd4b4333c4ab4@mail.gmail.com>
	 <1250589285.5150.1.camel@localhost.localdomain>
	 <9b2b86520908180623i4e7ce5cv9a4cd6b1704a0e5f@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 14:45:34 -0700
Message-Id: <1250631934.5150.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> >> In practice I suspect it makes no difference that the rfkill and
> >> backlight devices are exported as virtual devices with no physical
> >> parent.  I just don't think it's "right" :-).
> >
> > it actually does make a difference for hardware detection. We wanna have
> > them hanging of the compal platform device.
> 
> Ok.  I wasn't sure that userspace was allowed to rely on that, but I
> re-read Documentation/ABI/testing/sysfs-devices and I see now that it
> can be allowed.
> 
> Some of these issues with the compal-laptop work may come from copying
> dell-laptop.  dell-laptop is the only driver which creates rfkill
> devices without a parent device.  In fact, it doesn't even create a
> platform device :-).

then that should be fixed. All RFKILL switches should really have a
parent and not dangling around the virtual tree. Especially since they
have physical hardware in the system.

> I'll try sending a patch or two to clean up dell-laptop.  I don't have
> the hardware but it should be pretty mechanical, almost a copy+paste
> job from a "good" driver.

That would be good. I don't have the hardware either, but others here
can test it.

Regards

Marcel


