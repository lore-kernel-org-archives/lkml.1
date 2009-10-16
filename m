Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZJPKyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZJPKyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 06:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZJPKyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 06:54:44 -0400
Received: from poutre.nerim.net ([62.4.16.124]:65154 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbZJPKyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 06:54:43 -0400
Date: Fri, 16 Oct 2009 12:53:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] lm-sensors 3.1.1-3 not detecting sensors on Intel
    DP55KG motherboard? (chip ID: 0xb473)
Message-ID: <20091016125353.1c8795f4@hyperion.delvare>
In-Reply-To: <alpine.DEB.2.00.0910160553221.2841@p34.internal.lan>
References: <alpine.DEB.2.00.0910131743530.5034@p34.internal.lan>
	<alpine.DEB.2.00.0910140403150.15961@p34.internal.lan>
	<alpine.DEB.2.00.0910140856190.19307@p34.internal.lan>
	<20091015100557.22243433@hyperion.delvare>
	<alpine.DEB.2.00.0910150422400.21030@p34.internal.lan>
	<20091016111504.5d9cb0ba@hyperion.delvare>
	<alpine.DEB.2.00.0910160553221.2841@p34.internal.lan>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009 05:54:10 -0400 (EDT), Justin Piszcz wrote:
> # ./sensors-detect 
> # sensors-detect revision 5782 (2009-10-16 10:59:16 +0200)
> # Board: Intel Corporation DP55KG
> (...)
> Some Super I/O chips contain embedded sensors. We have to write to
> standard I/O ports to probe them. This is usually safe.
> Do you want to scan for Super I/O sensors? (YES/no): 
> Probing for Super-I/O at 0x2e/0x2f
> Trying family `National Semiconductor'...                   No
> Trying family `SMSC'...                                     No
> Trying family `VIA/Winbond/Nuvoton/Fintek'...               Yes
> Found `Nuvoton W83677HG-I Super IO Sensors'
>      (but no address specified)

So the LPC interface to the hardware monitoring chip is disabled.

> Next adapter: SMBus I801 adapter at 7000 (i2c-0)
> Do you want to scan it? (YES/no/selectively): 
> Client found at address 0x2c
> Probing for `Myson MTP008'...                               No
> Probing for `National Semiconductor LM78'...                No
> Probing for `National Semiconductor LM79'...                No
> Probing for `National Semiconductor LM80'...                No
> Probing for `National Semiconductor LM85'...                No
> Probing for `National Semiconductor LM96000 or PC8374L'...  No
> Probing for `Analog Devices ADM1027'...                     No
> Probing for `Analog Devices ADT7460 or ADT7463'...          No
> Probing for `SMSC EMC6D100 or EMC6D101'...                  No
> Probing for `SMSC EMC6D102'...                              No
> Probing for `SMSC EMC6D103'...                              No
> Probing for `Winbond WPCD377I'...                           No
> Probing for `Analog Devices ADT7470'...                     No
> Probing for `Analog Devices ADT7476'...                     No
> Probing for `Andigilog aSC7611'...                          No
> Probing for `Andigilog aSC7621'...                          No
> Probing for `National Semiconductor LM87'...                No
> Probing for `Analog Devices ADM1024'...                     No
> Probing for `National Semiconductor LM93'...                No
> Probing for `Winbond W83781D'...                            No
> Probing for `Winbond W83782D'...                            No
> Probing for `Winbond W83791D'...                            No
> Probing for `Winbond W83792D'...                            No
> Probing for `Winbond W83793R/G'...                          No
> Probing for `Nuvoton W83795G/ADG'...                        No
> Probing for `Winbond W83627HF'...                           No
> Probing for `Winbond W83627EHF'...                          No
> Probing for `Winbond W83627DHG'...                          No
> Probing for `Asus AS99127F (rev.1)'...                      No
> Probing for `Asus AS99127F (rev.2)'...                      No
> Probing for `Asus ASB100 Bach'...                           No
> Probing for `Genesys Logic GL518SM'...                      No
> Probing for `Genesys Logic GL520SM'...                      No
> Probing for `Analog Devices ADM9240'...                     No
> Probing for `Dallas Semiconductor DS1780'...                No
> Probing for `National Semiconductor LM81'...                No
> Probing for `Analog Devices ADM1026'...                     No
> Probing for `Analog Devices ADM1025'...                     No
> Probing for `Philips NE1619'...                             No
> Probing for `Analog Devices ADM1029'...                     No
> Probing for `Analog Devices ADM1030'...                     No
> Probing for `Analog Devices ADM1031'...                     No
> Probing for `Analog Devices ADM1022'...                     No
> Probing for `Texas Instruments THMC50'...                   No
> Probing for `ITE IT8712F'...                                No
> Probing for `ALi M5879'...                                  No
> Probing for `SMSC LPC47M15x/192/292/997'...                 No
> Probing for `SMSC DME1737'...                               No
> Probing for `SMSC SCH5027D-NW'...                           No
> Probing for `Winbond W83791SD'...                           No

You have an unknown chip at 0x2c on the SMBus. It could be a hardware
monitoring chip... or not.

If you want me to investigate this, you can provide an I2C dump of the
chip. Get i2cdump from the i2c-tools package, and then:

# i2cdump 0 0x2c b

This might confuse the chip in question though, so only try it if you
are ready to trigger a cold reboot.

> Client found at address 0x2d
> (...)
> Probing for `Winbond W83627DHG'...                          Success!
>      (confidence 8, driver `use-isa-instead')

This is the SMBus access to the W83677HG. We don't have support for
that, because LPC access is faster and was always enabled on all
motherboards we've seen so far.

I doubt we'll ever add SMBus access support, for both performance and
source code readability reasons. If anything, we could forcibly enable
the device on your motherboard. But please first look for BIOS options
and/or a BIOS update to enable the LPC interface.

Do you see any hardware monitoring information in the BIOS?

-- 
Jean Delvare
http://khali.linux-fr.org/wishlist.html
