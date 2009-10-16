Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZJPSl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZJPSl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZJPSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:41:55 -0400
Received: from bamako.nerim.net ([62.4.17.28]:64672 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbZJPSly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:41:54 -0400
Date: Fri, 16 Oct 2009 20:41:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] lm-sensors 3.1.1-3 not detecting sensors on Intel
     DP55KG motherboard? (chip ID: 0xb473)
Message-ID: <20091016204155.377fe67d@hyperion.delvare>
In-Reply-To: <alpine.DEB.2.00.0910160838500.31450@p34.internal.lan>
References: <alpine.DEB.2.00.0910131743530.5034@p34.internal.lan>
	<alpine.DEB.2.00.0910140403150.15961@p34.internal.lan>
	<alpine.DEB.2.00.0910140856190.19307@p34.internal.lan>
	<20091015100557.22243433@hyperion.delvare>
	<alpine.DEB.2.00.0910150422400.21030@p34.internal.lan>
	<20091016111504.5d9cb0ba@hyperion.delvare>
	<alpine.DEB.2.00.0910160553221.2841@p34.internal.lan>
	<20091016125353.1c8795f4@hyperion.delvare>
	<alpine.DEB.2.00.0910160838500.31450@p34.internal.lan>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009 09:40:51 -0400 (EDT), Justin Piszcz wrote:
> On Fri, 16 Oct 2009, Jean Delvare wrote:
> > If you want me to investigate this, you can provide an I2C dump of the
> > chip. Get i2cdump from the i2c-tools package, and then:
> >
> > # i2cdump 0 0x2c b
> >
> > This might confuse the chip in question though, so only try it if you
> > are ready to trigger a cold reboot.
> 
> Ok, luckily it does not appear to have caused any issues:
> 
> # i2cdump 0 0x2c b
> WARNING! This program can confuse your I2C bus, cause data loss and worse!
> I will probe file /dev/i2c-0, address 0x2c, mode byte
> Continue? [Y/n] y
>       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
> 00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> 10: 00 00 00 00 00 00 00 00 00 00 80 80 80 04 7e 10    ..........????~?
> 20: 75 51 c0 c3 c3 80 28 2d bd 0f de 0f 3b 1d a9 16    uQ????(-????;???
> 30: 33 4d 4d c2 81 00 c2 00 ff ff ff e6 7b fb 41 6f    3MM??.?....?{?Ao
> 40: 35 90 40 00 00 ff 00 ff 00 ff 00 ff 00 ff 81 7f    5?@...........??
> 50: 81 7f 81 7f ff ff ff ff ff ff ff ff 0a a2 a2 ca    ????........????
> 60: 8a 8a e0 aa 33 4c 4c 5a 2d 2d 64 41 41 04 42 00    ????3LLZ--dAA?B.
> 70: 00 00 00 00 00 00 6c 60 f0 00 00 55 01 00 00 00    ......l`?..U?...
> 80: 00 00 00 00 00 00 ff ff 00 00 fb 64 64 64 00 00    ..........?ddd..
> 90: 00 59 59 59 00 00 00 00 00 00 00 00 00 00 00 00    .YYY............
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
> #

Smells like an Analog Devices chip, but not one we know... And I can't
see it on the web site you mentioned. Please search for a small-size
chip named ADTxxxx (more likely ADT74xx).

-- 
Jean Delvare
