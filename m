Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbXAWEmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbXAWEmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 23:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbXAWEmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 23:42:36 -0500
Received: from theorix.CeNTIE.NET.au ([202.9.6.84]:49889 "HELO
	theorix.centie.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932270AbXAWEmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 23:42:35 -0500
Message-ID: <45B59239.90403@usherbrooke.ca>
Date: Tue, 23 Jan 2007 15:42:33 +1100
From: Jean-Marc Valin <jean-marc.valin@usherbrooke.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org
Subject: Re: Suspend to RAM generates oops and general protection fault
References: <45B422D3.9040409@usherbrooke.ca> <1169436221.2190.13.camel@nigel.suspend2.net> <45B448BA.70800@usherbrooke.ca> <20070122132545.GA4493@ucw.cz>
In-Reply-To: <20070122132545.GA4493@ucw.cz>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> will be a device driver. Common causes of suspend/resume problems from
>>> the list you give below are acpi modules, bluetooth and usb. I'd also be
>>> consider pcmcia, drm and fuse possibilities. But again, go for unloading
>>> everything possible in the first instance.
>> Actually, the reason I sent this is that when I showed the oops/gpf to
>> Matthew Garrett at linux.conf.au, he said it looked like a CPU hotplug
>> problem and suggested I send it to lkml. BTW, with 2.6.20-rc5, the
>> suspend to RAM now works ~95% of the time.
> 
> Try a kernel without CONFIG_SMP... that will verify if it is SMP
> related.

Well, this happens to be my main work machine, which I'm not willing to
have running at half speed for several weeks. Anything else you can suggest?

	Jean-Marc
