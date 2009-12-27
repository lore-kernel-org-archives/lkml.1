Return-Path: <linux-kernel-owner+w=401wt.eu-S1751401AbZL0WY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbZL0WY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 17:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbZL0WYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 17:24:25 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:49812 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZL0WYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 17:24:24 -0500
Message-ID: <4B37DE8F.1000806@epsm.fr>
Date: Sun, 27 Dec 2009 23:24:15 +0100
From: Didier Spaier <didier.spaier@epsm.fr>
User-Agent: Thunderbird 2.0.0.23 (X11/20090820)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, ibm-acpi-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ibm-acpi-devel] 2.6.33-rc2: regression: gkrellm no longer shows
 all the temperatures on thinkpad x60
References: <20091227215722.GN11737@elf.ucw.cz>
In-Reply-To: <20091227215722.GN11737@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> ...I'll have to find out where gkrell got that info. It worked in
> 2.6.32.
> 
> 									Pavel
Only to make sure... What is the output of cat /proc/acpi/ibm/thermal?

I ask that question because I noticed battery temperature 0° displayed  by conky after updating to 2.6.32.2.
Looking at my .conkyrc I saw I tried to display ${smapi_bat_temp 0} but I had forgotten to re-install the tp_smapi module.

May be gkrellm uses tp_smapi too??

PS what is worst, without tp_smapi hdaps do not work well either so I lost hard-disk parking on my Thinkpad T61 too... Hopefully meanwhile the laptop stayed nicely on my desk ;)


