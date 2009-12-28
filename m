Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbZL1KO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbZL1KO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZL1KO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:14:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44085 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZL1KO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:14:57 -0500
Date: Mon, 28 Dec 2009 11:14:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Didier Spaier <didier.spaier@epsm.fr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, len.brown@intel.com,
       ibm-acpi@hmh.eng.br, kernel list <linux-kernel@vger.kernel.org>,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] 2.6.33-rc2: regression: gkrellm no longer
 shows all the temperatures on thinkpad x60
Message-ID: <20091228101448.GB19984@elf.ucw.cz>
References: <20091227215722.GN11737@elf.ucw.cz>
 <4B37DE8F.1000806@epsm.fr>
 <20091227222659.GP11737@elf.ucw.cz>
 <4B37E09B.10309@epsm.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B37E09B.10309@epsm.fr>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-27 23:32:59, Didier Spaier wrote:
> Pavel Machek wrote:
> >On Sun 2009-12-27 23:24:15, Didier Spaier wrote:
> >>Pavel Machek wrote:
> >>>...I'll have to find out where gkrell got that info. It worked in
> >>>2.6.32.
> >>>
> >>>									Pavel
> >>Only to make sure... What is the output of cat /proc/acpi/ibm/thermal?
> >>
> >>I ask that question because I noticed battery temperature 0° displayed  by conky after updating to 2.6.32.2.
> >>Looking at my .conkyrc I saw I tried to display ${smapi_bat_temp 0}
> >but I had forgotten to re-install the tp_smapi module.
> >
> >Uhuh, there's no /proc/acpi/ibm:
> >
> >ls /proc/acpi/ibm         ls: cannot access /proc/acpi/ibm: No
> >such file or directory
> >
> >. I guess that's the problem :-(. Config is:
> >
> >CONFIG_THINKPAD_ACPI=y
> ># CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
> ># CONFIG_THINKPAD_ACPI_DEBUG is not set
> >CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
> >CONFIG_THINKPAD_ACPI_VIDEO=y
> ># CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
> >
> >...so I do not see "enable legacy interface" option.

> bash-3.1$ grep THINKPAD_ACPI /boot/config-2.6.32.2strip
> CONFIG_THINKPAD_ACPI=m
> CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
> CONFIG_THINKPAD_ACPI_DEBUG=y
> CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
> CONFIG_THINKPAD_ACPI_VIDEO=y
> CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
> bash-3.1$
> 
> I suggest you modularize THINKPAD_ACPI.

How would modular version help?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
