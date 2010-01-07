Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180Ab0AGVuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0AGVuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152Ab0AGVuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:50:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52274 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0AGVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:50:16 -0500
Date: Thu, 7 Jan 2010 22:49:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: kernel list <linux-kernel@vger.kernel.org>, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, ibm-acpi-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ibm-acpi-devel] 2.6.33-rc2: regression: gkrellm no longer
 shows all the temperatures on thinkpad x60
Message-ID: <20100107214904.GB25538@elf.ucw.cz>
References: <20091227215722.GN11737@elf.ucw.cz>
 <20091228130138.GA19362@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091228130138.GA19362@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Please apply the latest stack of patches (sent them to acpi-test
> yesterday).
> 
> It is failing to register the ALSA mixer for some reason, and due
> to a bug, it is not loading the module at all.  I will look at the reason it
> is failing to register the ALSA mixer soon.  Meanwhile, the patches I sent
> to Len make sure the module can still load sucessfully.

Well, I'm not sure its completely fixed. I got this in my syslog:

thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: temperatures (Celsius): 95 47 N/A 89 47 N/A 41 N/A 51
61 N/A N/A N/A N/A N/A N/A

...meaning thinkpad_acpi is active and working, but still gkrellm does
not report temperatures as it used to.

root@amd:~# cat /proc/acpi/ibm/thermal 
temperatures:	74 48 -128 75 47 -128 41 -128 51 58 -128 -128 -128
-128 -128 -128
root@amd:~# 

...is there, so I'm not sure why gkrellm stopped working.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
