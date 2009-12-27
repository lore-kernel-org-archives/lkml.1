Return-Path: <linux-kernel-owner+w=401wt.eu-S1751428AbZL0W1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbZL0W1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 17:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZL0W1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 17:27:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43662 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZL0W1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 17:27:12 -0500
Date: Sun, 27 Dec 2009 23:26:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Didier Spaier <didier.spaier@epsm.fr>
Cc: kernel list <linux-kernel@vger.kernel.org>, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, ibm-acpi-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ibm-acpi-devel] 2.6.33-rc2: regression: gkrellm no longer
 shows all the temperatures on thinkpad x60
Message-ID: <20091227222659.GP11737@elf.ucw.cz>
References: <20091227215722.GN11737@elf.ucw.cz>
 <4B37DE8F.1000806@epsm.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B37DE8F.1000806@epsm.fr>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-27 23:24:15, Didier Spaier wrote:
> Pavel Machek wrote:
> >...I'll have to find out where gkrell got that info. It worked in
> >2.6.32.
> >
> >									Pavel
> Only to make sure... What is the output of cat /proc/acpi/ibm/thermal?
> 
> I ask that question because I noticed battery temperature 0° displayed  by conky after updating to 2.6.32.2.
> Looking at my .conkyrc I saw I tried to display ${smapi_bat_temp 0}
but I had forgotten to re-install the tp_smapi module.

Uhuh, there's no /proc/acpi/ibm:

ls /proc/acpi/ibm         
ls: cannot access /proc/acpi/ibm: No such file or directory

. I guess that's the problem :-(. Config is:

CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set

...so I do not see "enable legacy interface" option.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
