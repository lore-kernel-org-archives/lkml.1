Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbXAWPOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbXAWPOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 10:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXAWPOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 10:14:54 -0500
Received: from 142.163.233.220.exetel.com.au ([220.233.163.142]:54634 "EHLO
	idefix.homelinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXAWPOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 10:14:54 -0500
X-Greylist: delayed 1287 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jan 2007 10:14:53 EST
Message-ID: <45B62163.4040704@usherbrooke.ca>
Date: Wed, 24 Jan 2007 01:53:23 +1100
From: Jean-Marc Valin <jean-marc.valin@usherbrooke.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org
Subject: Re: Suspend to RAM generates oops and general protection fault
References: <45B422D3.9040409@usherbrooke.ca>	 <1169436221.2190.13.camel@nigel.suspend2.net>	 <45B448BA.70800@usherbrooke.ca> <20070122132545.GA4493@ucw.cz>	 <45B59239.90403@usherbrooke.ca> <3877989d0701222311u5660a3c1id06bbeea3578a1c3@mail.gmail.com>
In-Reply-To: <3877989d0701222311u5660a3c1id06bbeea3578a1c3@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luming Yu a écrit :
> what about removing psmouse module?

Trying that now. Any particular reason you suspect that one?

	Jean-Marc

> On 1/23/07, Jean-Marc Valin <jean-marc.valin@usherbrooke.ca> wrote:
>> >>> will be a device driver. Common causes of suspend/resume problems
>> from
>> >>> the list you give below are acpi modules, bluetooth and usb. I'd
>> also be
>> >>> consider pcmcia, drm and fuse possibilities. But again, go for
>> unloading
>> >>> everything possible in the first instance.
>> >> Actually, the reason I sent this is that when I showed the oops/gpf to
>> >> Matthew Garrett at linux.conf.au, he said it looked like a CPU hotplug
>> >> problem and suggested I send it to lkml. BTW, with 2.6.20-rc5, the
>> >> suspend to RAM now works ~95% of the time.
>> >
>> > Try a kernel without CONFIG_SMP... that will verify if it is SMP
>> > related.
>>
>> Well, this happens to be my main work machine, which I'm not willing to
>> have running at half speed for several weeks. Anything else you can
>> suggest?
>>
>>         Jean-Marc
>> -
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
