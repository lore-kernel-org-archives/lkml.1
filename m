Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZJENtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZJENtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 09:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZJENts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 09:49:48 -0400
Received: from if2-fnarfbargle.com ([93.93.128.64]:51294 "EHLO fnarfbargle.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752056AbZJENts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 09:49:48 -0400
Message-ID: <4AC9F94B.3070701@wasp.net.au>
Date: Mon, 05 Oct 2009 21:48:59 +0800
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Luca Tettamanti <kronos.it@gmail.com>, lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com> <68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com> <4AC939BB.8090600@wasp.net.au> <4AC9B896.9080900@msgid.tls.msk.ru>
In-Reply-To: <4AC9B896.9080900@msgid.tls.msk.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Brad Campbell wrote:
> []
>> Vanilla Kernel 2.6.31.1 fails to load it87 on my machine with the same 
>> messages as posted above.
>>
>> [71916.534278] it87: Found IT8716F chip at 0x290, revision 0
>> [71916.535783] it87: in3 is VCC (+5V)
>> [71916.537239] it87: in7 is VCCH (+5V Stand-By)
>> [71916.538763] ACPI: I/O resource it87 [0x295-0x296] conflicts with 
>> ACPI region IP__ [0x295-0x296]
>> [71916.540365] ACPI: Device needs an ACPI driver
>>
>> In addition, asus_atk0110 loads but leaves no trace in dmesg when loaded.
> 
> try acpi_enforce_resources=lax kernel command-line parameter.

That certainly allows the it87 driver to load and function. I was more interested in seeing if the 
motherboard was able to be supported in the asus driver, but whatever works.

Cheers :)

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
