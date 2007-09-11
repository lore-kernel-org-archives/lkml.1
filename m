Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbXIKOdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbXIKOdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXIKOdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:33:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62802 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbXIKOdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:33:37 -0400
Message-ID: <46E6A737.6080805@anagramm.de>
Date: Tue, 11 Sep 2007 16:33:27 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Dag-Erling_Sm=F8rgrav?= <des@linpro.no>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC+PATCH] RTC calibration
References: <ujrmyvt2tyy.fsf@false.linpro.no>
In-Reply-To: <ujrmyvt2tyy.fsf@false.linpro.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19kWxAZpp+FX+Ma9JyuA7ZgsvgBoSzzR5qay0E
 8kn2FcxADLAOa2sNiOmKRUnvqMEGg9X+mLmEZN7YpX6odah8WH
 aEhDx75pI4CpeO0c0RKqw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dag-Erling Smørgrav schrieb:
 > The STMicroelectronics M41T11 is an RTC chip which is similar in most
 > ways to the Dallas/Maxim DS1307 or DS1337, except that it supports
 > software calibration:
 >
 > http://www.st.com/stonline/books/pdf/docs/6103.pdf
 >
 > I want to use this calibration feature [...]
 > [...]
 > In order to access this from userland, I've added two ioctls,
 > (RTC_SPEED_UP and RTC_SPEED_DOWN) with corresponding functions in
 > drivers/rtc/interface.c (rtc_speed_up() and rtc_speed_down()) and
 > corresponding slots in rtc_class_ops (speed_up and speed_down).

It looks odd to me to do only differential up and down adjustments.
I would prefer read_calibration_register and write_calibration_register
access and let the userspace decide how much it wants to
increment/decrement the register.

Or - do you adjust your date also after you changed your battery
with +1567days,7h,34m,12sec instead of telling it's 11th Sept. 2007, 4:33pm ?

Regards,

Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com

