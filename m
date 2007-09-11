Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbXIKPhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbXIKPhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbXIKPgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:36:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57885 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbXIKPgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:36:53 -0400
Message-ID: <46E6B617.7030106@anagramm.de>
Date: Tue, 11 Sep 2007 17:36:55 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Dag-Erling_Sm=F8rgrav?= <des@linpro.no>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC+PATCH] RTC calibration
References: <ujrmyvt2tyy.fsf@false.linpro.no> <46E6A737.6080805@anagramm.de> <ujrabrt2qkt.fsf@false.linpro.no>
In-Reply-To: <ujrabrt2qkt.fsf@false.linpro.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19M3b651blT77+FmK7e3bYBspzlofSCMdUwCdG
 OvL51U2KPaLomDNxO3q8ixULbsAdzVlckF9Nrp5VXx5H5dWufI
 g0kClvWA90G33EJtGov8g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dag-Erling Smørgrav schrieb:
 > Clemens Koller <clemens.koller@anagramm.de> writes:
 >> It looks odd to me to do only differential up and down adjustments.
 >> I would prefer read_calibration_register and write_calibration_register
 >> access and let the userspace decide how much it wants to
 >> increment/decrement the register.
 >
 > Without knowing exacly which chip is present, there is no way for the
 > userland calibration tool to know how big a difference a calibration
 > step makes.

I am not talking about the calibration algorithm and it's quality.
I am talking about _how_ the calibration register is addressed from
userspace. It's a simple register, some bits at address 7 and I would
expect to read/modify/write registers to do all the things you want
to do. Register access in userspace doesn't put any limitation
to applications.
Having only incs and decs without getting the actual value back seems
to be an absolutely unnecessary limitation here.
You cannot get the current value back to see if it's i.e. in saturation in
a way that it doesn't make sense to inc/decrement it further or in bigger steps
or reset it to zero...

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


