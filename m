Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYBRXff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYBRXff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYBRXf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:35:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:57441 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbYBRXf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:35:26 -0500
Message-ID: <47BA162C.5000807@anagramm.de>
Date: Tue, 19 Feb 2008 00:35:08 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net
CC: Krzysztof Helt <krzysztof.h1@poczta.fm>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, avorontsov@ru.mvista.com
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] fb: add support for foreign	endianness
References: <20080205154432.GA8749@localhost.localdomain>	<20080214224942.a0cb6218.akpm@linux-foundation.org>	<20080215164542.GB16810@localhost.localdomain>	<Pine.LNX.4.64.0802171030330.6848@anakin>	<20080218081847.e9e65f2f.krzysztof.h1@poczta.fm> <19805.1203355811@turing-police.cc.vt.edu>
In-Reply-To: <19805.1203355811@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/+jLh7L/cYjPYW4kM4kwzW3NUaAhSXj69qoFS
 n6AOsVooDojeD22E43AMDdvaI9XXlRCm/Oofm8aN9AXisC2Yos
 8qScpEK0/XjLAnf4ZNfvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu schrieb:
> On Mon, 18 Feb 2008 08:18:47 +0100, Krzysztof Helt said:
>> I know two fb drivers which use endianess information (pm2fb and s3c2410fb).
>> Both resolve endianess at driver level. Actually, both handle it by setting special
>> bits so the graphics chip itself reorder bytes to transform foreign endianess. 
>> I understand that this patch is for chips which cannot reorder bytes by themselves.
> 
> Does anybody know of such a chip that's actually available in the wild?  Or are
> we writing drivers for speculative possible chips?
> 

I had troubles with the Silicon Motion SM501/SM502 endianess on PowerPC PCI vs. LocalBus.
The chip also has a register to swap endianess, but that seems to only affect some
LocalBus modes.
The current fb and X drivers are working, but when it comes to font
aliasing and hw-acceleration, the problems start to rise again...

Regards,

Clemens
