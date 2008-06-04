Return-Path: <linux-kernel-owner+w=401wt.eu-S1763286AbYFDXoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763286AbYFDXoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbYFDXnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:43:52 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:10297 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbYFDXnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:43:50 -0400
X-Spam-Flag: NO
X-Spam-Score: -8.389
Message-ID: <484728B2.1000209@tremplin-utc.net>
Date: Thu, 05 Jun 2008 01:43:46 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.14) Gecko/20080504 Mandriva/2.0.0.14-1mdv2009.0 (2009.0) Thunderbird/2.0.0.14 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: Jean Delvare <khali@linux-fr.org>, Andrew Morton <akpm@osdl.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection  System 3D
 ACPI driver -- please review!
References: <1212235533.3815.5.camel@localhost> <4846EBF5.2030406@tremplin-utc.net> <20080604225830.1dff64fc@hyperion.delvare> <20080604230510.GB30475@elf.ucw.cz>
In-Reply-To: <20080604230510.GB30475@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05-06-08 01:05, Pavel Machek wrote/a écrit:
> Hi!
> 
>> So my advice is that you don't wait for a review from the hwmon people,
>> because apparently we don't have much interest in this type of device,
>> so you'll be waiting forever. You're much better adding the mdps driver
>> to drivers/misc through Andrew Morton, at least until someone takes
>> care of creating a subsystem for this type of devices and move all
>> existing drivers there.
> 
> Just create drivers/accel ... accelerometers are quite common these
> days. Going to drivers/misc is okay, too, I guess -- moves are easy
> with git ;-).
Yes, why not do one little step to the correct direction now and create
drivers/accel, it will likely be the chosen name anyway! That will not
yet be a "real" subsystem, just a place to put all the related drivers
already present together.
Anyone against this idea?

Eric
