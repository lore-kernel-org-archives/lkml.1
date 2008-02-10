Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYBJTEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYBJTEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYBJTEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:04:11 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:33301 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbYBJTEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=VxTKR5xuNT2v+rE9b6DCMQA5bAvK5ZM2/HHDLZetj2gRI+FsGwGawxiKH4gvJUGqSnf9A9OhucHiZe1EvG/kr3dMSN9osG19hVs5cIAo2wbWeuIb7tPwZx6wUuEHEV22XVlpPse572OrOJUTMoGjY/qif+9/yURx4erlwZA6Occ=
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] wireless: rt2x00: fix driver menu indenting
Date: Sun, 10 Feb 2008 20:03:25 +0100
User-Agent: KMail/1.9.7
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-wireless@vger.kernel.org,
       Michael =?iso-8859-1?q?B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       linville@tuxdriver.com
References: <200802091623.06504.m.bueker@berlin.de> <20080210105252.e0a433ee.randy.dunlap@oracle.com>
In-Reply-To: <20080210105252.e0a433ee.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802102003.25392.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008, Randy Dunlap wrote:
> On Sat, 9 Feb 2008 16:23:06 +0100 Michael Büker wrote:
> 
> > 2) When selecting "Ralink driver support" (CONFIG_RT2X00), the accompanying 
> > drivers (CONFIG_RT2400PCI, CONFIG_RT61PC, ...) appear unindented. They should 
> > be indented by four spaces.
> 
> Yes, patch is below.
> 
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Michael Büker <m.bueker@berlin.de> reports that the RT2x00 drivers
> are not indented as they should be, so use proper dependencies to make
> them be indented as expected.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Ack-by: Ivo van Doorn <IvDoorn@gmail.com>

---
John,
Could you push this directly into wireless-2.6 and probably upstream as well.

Thanks.

Ivo

> ---
>  drivers/net/wireless/rt2x00/Kconfig |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> --- linux-2.6.24-git21.orig/drivers/net/wireless/rt2x00/Kconfig
> +++ linux-2.6.24-git21/drivers/net/wireless/rt2x00/Kconfig
> @@ -11,18 +11,17 @@ config RT2X00
>  	  will also be created. That library (when the driver is built as
>  	  a module) will be called "rt2x00lib.ko".
>  
> +if RT2X00
> +
>  config RT2X00_LIB
>  	tristate
> -	depends on RT2X00
>  
>  config RT2X00_LIB_PCI
>  	tristate
> -	depends on RT2X00
>  	select RT2X00_LIB
>  
>  config RT2X00_LIB_USB
>  	tristate
> -	depends on RT2X00
>  	select RT2X00_LIB
>  
>  config RT2X00_LIB_FIRMWARE
> @@ -39,7 +38,7 @@ config RT2X00_LIB_RFKILL
>  
>  config RT2400PCI
>  	tristate "Ralink rt2400 pci/pcmcia support"
> -	depends on RT2X00 && PCI
> +	depends on PCI
>  	select RT2X00_LIB_PCI
>  	select EEPROM_93CX6
>  	---help---
> @@ -58,7 +57,7 @@ config RT2400PCI_RFKILL
>  
>  config RT2500PCI
>  	tristate "Ralink rt2500 pci/pcmcia support"
> -	depends on RT2X00 && PCI
> +	depends on PCI
>  	select RT2X00_LIB_PCI
>  	select EEPROM_93CX6
>  	---help---
> @@ -77,7 +76,7 @@ config RT2500PCI_RFKILL
>  
>  config RT61PCI
>  	tristate "Ralink rt61 pci/pcmcia support"
> -	depends on RT2X00 && PCI
> +	depends on PCI
>  	select RT2X00_LIB_PCI
>  	select RT2X00_LIB_FIRMWARE
>  	select EEPROM_93CX6
> @@ -97,7 +96,7 @@ config RT61PCI_RFKILL
>  
>  config RT2500USB
>  	tristate "Ralink rt2500 usb support"
> -	depends on RT2X00 && USB
> +	depends on USB
>  	select RT2X00_LIB_USB
>  	---help---
>  	  This is an experimental driver for the Ralink rt2500 wireless chip.
> @@ -106,7 +105,7 @@ config RT2500USB
>  
>  config RT73USB
>  	tristate "Ralink rt73 usb support"
> -	depends on RT2X00 && USB
> +	depends on USB
>  	select RT2X00_LIB_USB
>  	select RT2X00_LIB_FIRMWARE
>  	---help---
> @@ -128,3 +127,4 @@ config RT2X00_DEBUG
>  	---help---
>  	  Enable debugging output for all rt2x00 modules
>  
> +endif
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Rt2400-devel mailing list
> Rt2400-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/rt2400-devel
> 


