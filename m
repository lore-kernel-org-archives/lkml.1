Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYFFPbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYFFPbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbYFFPbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:31:09 -0400
Received: from correo14.acens.net ([217.116.0.88]:55076 "EHLO
	correo14.acens.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbYFFPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:31:08 -0400
Message-ID: <48495831.3050404@eslack.org>
Date: Fri, 06 Jun 2008 17:30:57 +0200
From: Pau Oliva Fora <pau@eslack.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Eric Piel <E.A.B.Piel@tudelft.nl>
CC: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>,
       Jonathan Cameron <jic23@cam.ac.uk>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@osdl.org>, Torokhov <dmitry.torokhov@gmail.com>,
       Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Pavel Machek <pavel@suse.cz>, Yan@ATrpms.net, Dmitry@ATrpms.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [lm-sensors] [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection
 System 3D ACPI driver -- please review!
References: <1212235533.3815.5.camel@localhost>	<4846EBF5.2030406@tremplin-utc.net>	<20080604225830.1dff64fc@hyperion.delvare>	<20080604230510.GB30475@elf.ucw.cz>	<484728B2.1000209@tremplin-utc.net> <20080605082950.6957f1a2@hyperion.delvare> <4847B415.2080708@cam.ac.uk> <48484DD6.3050706@tremplin-utc.net> <4848683E.4070709@eslack.org> <48495017.8040003@tudelft.nl>
In-Reply-To: <48495017.8040003@tudelft.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Piel wrote:
> Pau Oliva Fora wrote:
>> Here's an i2c version of the driver for the LIS3LV02DL accelerometer,
>> please try to combine it too, so we'll end up having ACPI, SPI and I2C.
> Whaoo, you went fast!
> As there is a dmi_match, that shouldn't be too hard to incorporate it 
> nicely :-)
> 
> BTW, do you really need the invert_x and invert_y and swap_xy 
> parameters? Don't all the HTC shift laptops have the sensors soldered 
> the same way? We've worked hard to remove those parameters in mdps ;-)
> 

Yes, you can remove the module params, and use the same approach you 
have based in DMI table.

Cheers,

	Pau Oliva
