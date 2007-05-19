Return-Path: <linux-kernel-owner+w=401wt.eu-S1763327AbXESPXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763327AbXESPXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 11:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758853AbXESPXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 11:23:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49594 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825AbXESPXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 11:23:48 -0400
Message-ID: <464F167A.1090706@anagramm.de>
Date: Sat, 19 May 2007 17:23:38 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: segher@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: gcc-4.2.0 breakage on powerpc?
References: <200705190953.l4J9rjO2024613@harpo.it.uu.se>
In-Reply-To: <200705190953.l4J9rjO2024613@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+UAlvgKjVAKkiXfkM/GZ6SinfpDQFFVYmobTL
 VSyB/ClIo4gLaVyvmHZ/FRCQuJOhlZD2qVzwsbp7APqLsVetCn
 e5vGqi6q08heqrDVMyiFg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson schrieb:
> On Sat, 19 May 2007 01:39:43 +0200, Segher Boessenkool wrote:
>>> and we'll end up
>>> having major kernel releases which don't build on i386 with major gcc
>>> releases, which isn't altogether desirable.
>> Yeah, like 4.2.0 with powerpc.  Seems like no one tested it :-(
> 
> Details please. What exactly are the gcc-4.2.0 problems on powerpc?

[embedded platform!]
Over here, the 2.6.21.1 Kernel _builds_ fine with gcc-4.2.0 on an mpc8540 e500 powerpc
(mpc8540_ads_defconfig) but it just crashes silently on boot. But that's IMHO a
DeviceTree/U-Boot issue I haven't solved yet.

$ uname -a
Linux ecam.anagramm.de 2.6.21-rc5-g9a5ee4cc #4 Mon Apr 2 21:31:53 CEST 2007 ppc e500 GNU/Linux
ARCH=ppc compiled with GCC-4.1.2 works fine.

Greets,

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
