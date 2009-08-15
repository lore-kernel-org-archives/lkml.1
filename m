Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbZHOGPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbZHOGPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 02:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbZHOGPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 02:15:08 -0400
Received: from smtp.nokia.com ([192.100.105.134]:55421 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZHOGPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 02:15:07 -0400
Message-ID: <4A865258.5090903@gmail.com>
Date: Sat, 15 Aug 2009 09:14:48 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
References: <20090814170228.GM13320@pengutronix.de> <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com>
In-Reply-To: <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Aug 2009 06:14:50.0907 (UTC) FILETIME=[B2A2CEB0:01CA1D6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2009 11:04 PM, Denys Vlasenko wrote:
>> [  2.742628]<    0.016050>  0x000000360000-0x000004000000 : "root"
>> [  3.058610]<    0.315982>  UBI: attaching mtd7 to ubi0
>> [  3.062878]<    0.004268>  UBI: physical eraseblock size:   16384 bytes (16 KiB)
>> [  3.070601]<    0.007723>  UBI: logical eraseblock size:    15360 bytes
>> [  3.070665]<    0.000064>  UBI: smallest flash I/O unit:    512
>> [  3.078564]<    0.007899>  UBI: VID header offset:          512 (aligned 512)
>> [  3.078609]<    0.000045>  UBI: data offset:                1024
>> [  5.006609]<    1.928000>  UBI: attached mtd7 to ubi0
>> [  5.013157]<    0.006548>  UBI: MTD device name:            "root"
>
> As others commented, ubi looks slow and you probably need to find out why.

Right. UBI is rather slow in attaching MTD devices. Everything is explained
here:

http://www.linux-mtd.infradead.org/doc/ubi.html#L_scalability
http://www.linux-mtd.infradead.org/doc/ubifs.html#L_scalability

There is not very much you can do to speed it up but implement UBI2. UBIFS
would stay intact. There were discussions about this and it does not seem
to be impossibly difficult to do UBI2. Here are few ideas:

http://www.linux-mtd.infradead.org/faq/ubi.html#L_attach_faster

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
