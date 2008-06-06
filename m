Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbYFFPaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbYFFPaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbYFFP34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:29:56 -0400
Received: from correo3.acens.net ([217.116.0.35]:33779 "EHLO correo3.acens.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbYFFP3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:29:55 -0400
Message-ID: <484957E8.4020404@eslack.org>
Date: Fri, 06 Jun 2008 17:29:44 +0200
From: Pau Oliva Fora <pau@eslack.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: ?ric Piel <Eric.Piel@tremplin-utc.net>, Jonathan Cameron <jic23@cam.ac.uk>,
       Jean Delvare <khali@linux-fr.org>, Andrew Morton <akpm@osdl.org>,
       Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Pavel Machek <pavel@suse.cz>, Yan@ATrpms.net, Dmitry@ATrpms.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [lm-sensors] [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection
 System 3D ACPI driver -- please review!
References: <1212235533.3815.5.camel@localhost> <4846EBF5.2030406@tremplin-utc.net> <20080604225830.1dff64fc@hyperion.delvare> <20080604230510.GB30475@elf.ucw.cz> <484728B2.1000209@tremplin-utc.net> <20080605082950.6957f1a2@hyperion.delvare> <4847B415.2080708@cam.ac.uk> <48484DD6.3050706@tremplin-utc.net> <4848683E.4070709@eslack.org> <20080606102237.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080606102237.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi,
> 
> On Fri, Jun 06, 2008 at 12:27:10AM +0200, Pau Oliva Fora wrote:
>> From: Pau Oliva Fora <pau@eslack.org>
>>
>> Add support for HTC Shift UMPC G-Sensor LIS3LV02DL accelerometer.
>>
>> Signed-off-by: Pau Oliva Fora <pau@eslack.org>
>>
> 
> The input piece looks good, however it seens that the input is the
> only functionality that this driver exports so I don't see any reason
> to make input device registration optional. Or are you planning on
> adding more functions to it?
> 

I wasn't planning on adding more functions, I posted it so that Éric
can have a look at the i2c part and integrate it in his driver.

	Pau Oliva

