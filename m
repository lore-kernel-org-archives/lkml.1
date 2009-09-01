Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbZIAINt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbZIAINt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZIAINs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:13:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60162 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbZIAINq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:13:46 -0400
Date: Tue, 1 Sep 2009 10:13:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH V6 2/2] introduce ACPI ALS device driver
Message-ID: <20090901081342.GB9942@elf.ucw.cz>
References: <1251789956.3483.216.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251789956.3483.216.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> ACPI spec defines ACPI Ambient Light Sensor device (hid ACPI0008),
> which provides a standard interface by which the OS may query properties
> of the ambient light environment the system is currently operating in,
> as well as the ability to detect meaningful changes in these values when
> the environment changes.

> +struct acpi_als {
> +	struct acpi_device *device;
> +	struct als_device *als_sys;
> +	int illuminance;
> +	int chromaticity;
> +	int temperature;
> +	int polling;
> +	int count;
> +	struct als_mapping *mappings;
> +};

chromaticity is write-only variable. I believe you can drop it and
associted code.

temperature ditto. Drop from this version?

polling ditto. Drop from this version?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
