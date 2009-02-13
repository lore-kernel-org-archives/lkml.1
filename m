Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbZBMTez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbZBMTez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZBMTej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:34:39 -0500
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:43614 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZBMTeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:34:37 -0500
References: <cone.1234471033.988571.5384.1000@mentalhome> <loom.20090213T092444-966@post.gmane.org>
Message-ID: <cone.1234553680.565932.4642.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Acer Aspire One fan control
Date: Fri, 13 Feb 2009 20:34:40 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger writes:

> 
> Does it help if you do:
> echo 10 >/proc/acpi/thermal_zone/*/polling_frequency

Actually there is nothing in /proc/acpi/thermal_zone/. So it seems for me, 
that there is no driver which handles the temperature and the fan of the 
Acer Aspire One yet. A search on google didn't disprove it. That's why I 
started to write my own kernel module. But I tested it only with 2.6.28.4. 
Maybe there's already something in 2.6.29, not sure about it. 

> If the fan is controlled via thermal ACPI trip points, maybe latest kernel
> versions do help? There were several commits lately in this area, e.g.:
> 676962dac6e267ce7c13f73962208f9124a084bb
> f5adfaa372c76423b6e8e4727a9701330374f364

Those patches have been applied to 2.6.28.

> The latter adds a boot param you could give a try if you think it's worth it:
> ACPI: Add "acpi.power_nocheck=1" to disable power state check in power
> transition

I will try the acpi.power_nocheck option, but google results on that don't 
sound very promising.

--peter
