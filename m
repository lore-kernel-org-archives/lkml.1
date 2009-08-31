Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZHaIvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZHaIvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZHaIvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:51:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:4994 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZHaIvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:51:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,304,1249282800"; 
   d="scan'208";a="722461453"
Subject: Re: [PATCH V5 1/2] introduce ALS sysfs class
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
In-Reply-To: <20090831083449.GB11117@elf.ucw.cz>
References: <1251706028.3483.160.camel@rzhang-dt>
	 <20090831083449.GB11117@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 16:48:57 +0800
Message-Id: <1251708537.3483.191.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-31 at 16:34 +0800, Pavel Machek wrote:
> Hi!
> 
> > @@ -0,0 +1,32 @@
> > +What:		/sys/class/als/als[0-N]/desc
> > +Date:		Aug. 2009
> > +KernelVersion:	2.6.32
> > +Contact:	Zhang Rui <rui.zhang@intel.com>
> > +Description:	Strings which descibes the current Ambient Light Sensor
> > +		device. This is given by native ALS driver as part of
> > +		registration. e.g: "acpi_als" for ACPI ALS devices.
> > +		RO
> 
> Normal way to do that (backlight class does it, for example) is to
> have acpi_als instead of als0, and get rid of desc field.

IMO, both are okay, hard to say which is preferred.
Other sysfs classes like scsi_host, hwmon, input use this as well.
and you don't have a really strong objection to this, right? :)

thanks,
rui

