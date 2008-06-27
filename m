Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYF0Cpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYF0Cpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 22:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbYF0Cpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 22:45:30 -0400
Received: from fmailhost02.isp.att.net ([204.127.217.102]:39929 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYF0Cp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 22:45:29 -0400
X-Originating-IP: [74.251.44.65]
Date: Thu, 26 Jun 2008 21:45:10 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Jie Yang <Jie.Yang@Atheros.com>
Cc: "jeff@garzik.org" <jeff@garzik.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2.6.25.3 1/5] atl1e: Atheros L1E Gigabit Ethernet driver
Message-ID: <20080626214510.01373505@osprey.hogchain.net>
In-Reply-To: <72981EBCFD196144B7C6999B9FC34A9A3EE603B863@SHEXMB-01.global.atheros.com>
References: <72981EBCFD196144B7C6999B9FC34A9A3EE603B863@SHEXMB-01.global.atheros.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEV2dXOAgYNxSD+aemaal42A
 gIBqYV2UU07Ik5GXfoFMRTdbKiVwAAACbUlEQVQ4jXXTzWvbMBQAcG3EZsmt0Owc3pgNPo1oxNFt
 pQnEN3Wrs3UnkdXq5tOwIdq9Pci3gUqJexo55KC/cs9O/dHBRIiMfpb03rNE4v800jxIQRzsXPEP
 jDwndhNelo9/ngE/SFdKmZQnfOT0YSSlQBKLiJBDH6w9SPwlp5evpduDr9biQqkV8Rh7p4NRNSO1
 4BHhpjLpIK2gWksIgl0LPLCHoBIcX6dp2kGKMYnfGJnjIFungZeuHA6dhSvqLXrA1zJmVKayCu1w
 DKuGAU+WZRRCsLdBFXgLl2Sw3N2ZEJDAn3VwEV9FK12YUGW+yqlIWiD30U5rbSi2efGuhRfxEXRB
 8e+uJE/AL5z78xrqVg6aBHlMTj9V7x/RJOMGHHI11ItVUW+B0JakkGPcUsJNHuY7/ZA04X4xwQ/D
 3I0FGgaT8iFponoJ26F+sNbu51O7l7QHHtNTbxMc5o/W+kw0S31Ub5i+pQBq/hjYPVPbJ/ic/aoC
 pbTQtxlAvvnZgNod89Y4D2sFXpMHZWU1yHb6Ft+g2aTJY84iY2iY4ySGmWdvmxlDprHkCgd1yDRV
 bXVfFQiZjyuyaU5p1pZkTbXBbxRagAyU2rZfcH2tTQ7+FpNQ4Ofb7lxdFzTHDGqAvHdEv0cIezi2
 be+0vzdUqawaDSATHfB7itGiIfrQu2p8UQOOooHTh5lUPn6lva/qQrWwQpCUTv08hGe3dkU9KWmJ
 Z2EGpAeDFc3kN8oMNbNJ/AzMFERUhjmehB7ws6XBTTnfeOXT9T/C9dn4HEshpPWIjDvgi5Px2U0G
 Hl7dzaQHg8U4Xn6oa4g3vVnqLz3ribDLdyFmAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches 1 and 2 reviewed tonight.  I intend to review the other 3 in
coming days.

On Thu, 26 Jun 2008 13:37:23 +0800
Jie Yang <Jie.Yang@Atheros.com> wrote:

> From: Jie Yang <jie.yang@atheros.com>
> 
> Full patch for the Atheros L1E Gigabit Ethernet driver.
> Supportring AR8121, AR8113 and AR8114

Please generate the patch against current mainline (or at least
current -rc); it fails to apply cleanly as is.

> 
> Signed-off-by: Jie Yang <jie.yang @atheros.com>
> ---
> diff -uprN -X linux-2.6.25.3.orig/Documentation/dontdiff
> linux-2.6.25.3.orig/drivers/net/atl1e/Makefile
> linux-2.6.25.3.atheros/drivers/net/atl1e/Makefile ---
> linux-2.6.25.3.orig/drivers/net/atl1e/Makefile      1970-01-01
> 08:00:00.000000000 +0800 +++
> linux-2.6.25.3.atheros/drivers/net/atl1e/Makefile   2008-06-20
> 11:22:34.000000000 +0800 @@ -0,0 +1,2 @@ +obj-$(CONFIG_ATL1E)    +=
> atl1e.o +atl1e-y                        += atl1e_main.o atl1e_hw.o
> atl1e_ethtool.o atl1e_param.o diff -uprN -X

Use tabs, not spaces, for indentation.  Run scripts/checkpatch.pl on
each patchfile and try to eliminate as many errors as you can.  There
are hundreds of checkpatch-reported errors in your submitted patches.

> linux-2.6.25.3.orig/Documentation/dontdiff
> linux-2.6.25.3.orig/drivers/net/Kconfig
> linux-2.6.25.3.atheros/drivers/net/Kconfig ---
> linux-2.6.25.3.orig/drivers/net/Kconfig     2008-05-10
> 12:48:50.000000000 +0800 +++
> linux-2.6.25.3.atheros/drivers/net/Kconfig  2008-06-19
> 18:17:42.000000000 +0800 @@ -2445,6 +2445,32 @@ config ATL1 To
> compile this driver as a module, choose M here.  The module will be
> called atl1.
> 
> +config ATL1E
> +       tristate "Atheros L1e Gigabit Ethernet support (EXPERIMENTAL)"
> +       depends on PCI && EXPERIMENTAL
> +       select CRC32
> +       select MII
> +       help
> +         This driver supports the Atheros L1E gigabit ethernet
> adapter. +
> +         To compile this driver as a module, choose M here.  The
> module
> +         will be called atl1e.
> +
> +config ATL1E_NAPI
> +       bool "Use Rx Polling (NAPI)"
> +       depends on ATL1E
> +       help
> +         NAPI is a new driver API designed to reduce CPU and
> interrupt load
> +         when the driver is receiving lots of packets from the card.
> It is
> +         still somewhat experimental and thus not yet enabled by
> default. +
> +         If your estimated Rx load is 10kpps or more, or if the card
> will be
> +         deployed on potentially unfriendly networks (e.g. in a
> firewall),
> +         then say Y here.
> +
> +         If in doubt, say N.
> +
> +

Remove extra blank line.

>  endif # NETDEV_1000
> 
>  #
> diff -uprN -X linux-2.6.25.3.orig/Documentation/dontdiff
> linux-2.6.25.3.orig/drivers/net/Makefile
> linux-2.6.25.3.atheros/drivers/net/Makefile ---
> linux-2.6.25.3.orig/drivers/net/Makefile    2008-05-10
> 12:48:50.000000000 +0800 +++
> linux-2.6.25.3.atheros/drivers/net/Makefile 2008-06-20
> 09:48:38.000000000 +0800 @@ -16,6 +16,7 @@ obj-$(CONFIG_EHEA) +=
> ehea/ obj-$(CONFIG_CAN) += can/ obj-$(CONFIG_BONDING) += bonding/
> obj-$(CONFIG_ATL1) += atl1/ +obj-$(CONFIG_ATL1E) += atl1e/
> obj-$(CONFIG_GIANFAR) += gianfar_driver.o obj-$(CONFIG_TEHUTI) +=
> tehuti.o
> 
> diff -uprN -X linux-2.6.25.3.orig/Documentation/dontdiff
> linux-2.6.25.3.orig/include/linux/pci_ids.h
> linux-2.6.25.3.atheros/include/linux/pci_ids.h ---
> linux-2.6.25.3.orig/include/linux/pci_ids.h 2008-05-10
> 12:48:50.000000000 +0800 +++
> linux-2.6.25.3.atheros/include/linux/pci_ids.h      2008-06-20
> 09:43:40.000000000 +0800 @@ -2175,6 +2175,7 @@
> 
>  #define PCI_VENDOR_ID_ATTANSIC         0x1969
>  #define PCI_DEVICE_ID_ATTANSIC_L1      0x1048
> +#define PCI_DEVICE_ID_ATTANSIC_L1E     0x1026
> 
>  #define PCI_VENDOR_ID_JMICRON          0x197B
>  #define PCI_DEVICE_ID_JMICRON_JMB360   0x2360
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
