Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbXJHXrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbXJHXrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbXJHXqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:46:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57455 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbXJHXqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:46:52 -0400
Message-ID: <470AC166.20705@anagramm.de>
Date: Tue, 09 Oct 2007 01:46:46 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: tglx@linutronix.de, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: sleepy linux 2.6.23-rc9
References: <20071008220506.GE3484@elf.ucw.cz>
In-Reply-To: <20071008220506.GE3484@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19iw9ZGNpjIdYW3efuFwYJUVOaFifyx27fTLvP
 hQueBvQvZUPIePsM9MQs1cV/gbRlO5TI5WzlaEdMYeghLfFm76
 +Cb6sxeViOIf45tfoylOw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek schrieb:
> I played with powertop a bit, and found a fairly interesting failure
> mode. If I boot init=/bin/bash vga=1, I get ~2 wakeups a second, nice.
> 
> When I boot init=/bin/bash vga=791 (vesa framebuffer), most wakeups
> are caused by cursor painting (I should fix that some day, I
> guess). But... the cursor blinking does not even work properly!
> 
> It blinks at normal speed, then (randomly) it blinks slowly, then gets
> back to normal speed, then inserts longer delay.

Is the effect a beat that it has roughly the frequency of your Notebooks
screen refresh rate (60Hz)? (in german: Schwebung)

> The effect is so nice that I thought about youtube ;-). Thinkpad
> x60.. question is, how to debug it? 

No idea... check where the register of the HW cursor blink rate
gets written? But as it seems to be so nice, please submit a patch
which enables this for all platforms. ;-)

Regards,
-- 
Clemens Koller
_______________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Str. 45/1
81379 Muenchen
Germany

http://www.anagramm-technology.com
Phone: +49-89-741518-50
Fax: +49-89-741518-19
