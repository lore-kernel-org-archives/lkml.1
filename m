Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbZIAIlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbZIAIlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZIAIlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:41:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:29628 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZIAIln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:41:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,311,1249282800"; 
   d="scan'208";a="546605991"
Subject: Re: [PATCH V6 2/2] introduce ACPI ALS device driver
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <20090901081342.GB9942@elf.ucw.cz>
References: <1251789956.3483.216.camel@rzhang-dt>
	 <20090901081342.GB9942@elf.ucw.cz>
Content-Type: text/plain; charset=utf-8
Date: Tue, 01 Sep 2009 16:39:36 +0800
Message-Id: <1251794376.3483.238.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 16:13 +0800, Pavel Machek wrote:
> Hi!
> 
> > ACPI spec defines ACPI Ambient Light Sensor device (hid ACPI0008),
> > which provides a standard interface by which the OS may query properties
> > of the ambient light environment the system is currently operating in,
> > as well as the ability to detect meaningful changes in these values when
> > the environment changes.
> 
> > +struct acpi_als {
> > +	struct acpi_device *device;
> > +	struct als_device *als_sys;
> > +	int illuminance;
> > +	int chromaticity;
> > +	int temperature;
> > +	int polling;
> > +	int count;
> > +	struct als_mapping *mappings;
> > +};
> 
> chromaticity is write-only variable.

>  I believe you can drop it and
> associted code.
> 
> temperature ditto. Drop from this version?
> 
> polling ditto. Drop from this version?
> 
﻿color temperature, chromaticity and polling are three optional features
defined in the ACPI spec, which are not supported yet in the ACPI ALS
driver right now.

I think it's okay to add the code first and then generate some
incremental patches to enable these features once we found such kind of
platforms.

thanks,
rui


> Thanks,
> 									Pavel

