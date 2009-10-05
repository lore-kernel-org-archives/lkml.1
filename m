Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZJEQm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZJEQm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 12:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZJEQm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 12:42:56 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:41379 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbZJEQmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 12:42:55 -0400
Message-ID: <4ACA21E8.6080501@msgid.tls.msk.ru>
Date: Mon, 05 Oct 2009 20:42:16 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Brad Campbell <brad@wasp.net.au>, lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>	 <68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>	 <4AC939BB.8090600@wasp.net.au> <68676e00910050837g2006bfb8j349891504e474a95@mail.gmail.com>
In-Reply-To: <68676e00910050837g2006bfb8j349891504e474a95@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
[]
>> Vanilla Kernel 2.6.31.1 fails to load it87 on my machine with the same
>> messages as posted above.
[]
>> In addition, asus_atk0110 loads but leaves no trace in dmesg when loaded.
> 
> That's good ;-) The driver is quiet when everything is ok. You should
> see the corresponding entries under /sys/class/hwmon/hwmonN; upgrade
> lm-sensor package to version 3.1.1, older versions do not support ACPI
> devices.
> 
>> Motherboard is an Asus M2N32-WS. DSDT attached.
> 
> From a quick glance it should work. If it doesn't enable
> CONFIG_HWMON_DEBUG_CHIP.

Well, I just tried it here and it works here too, on 3 different
asus motherboards.  But asus_atk0110 is far less useful than the
it87 variant.  Yes atk0110 shows correct labels for various sensors,
but for one there's no way to control fan speeds using it, at least
not currently, -- something which is done by it87 easily.

Well, one more difference is that atk0110 also shows vcore, which
at least looks real instead of fake 1.55V as shown by it87.

But anyway, loading the driver just to get correct labels and
vcore seems a bit overkill...

/mjt
