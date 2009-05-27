Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbZE0Uae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbZE0Uae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZE0U3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:29:49 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:55713 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbZE0U3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:29:46 -0400
Message-ID: <4A1DA24D.5000101@freescale.com>
Date: Wed, 27 May 2009 15:27:57 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090504 SeaMonkey/2.0a3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: scottwood@freescale.com, rmk+lkml@arm.linux.org.uk, jacmet@sunsite.dk,
       r.schwebel@pengutronix.de, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       yuan-bo.ye@motorola.com
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
References: <20090527192909.GA32398@flint.arm.linux.org.uk>	<4A1D9A1E.80603@freescale.com>	<4A1D9A66.5020002@freescale.com> <20090527.132553.40558501.davem@davemloft.net>
In-Reply-To: <20090527.132553.40558501.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> It depends.  Some devices have EEPROM's that store the permanently
> assigned MAC address, some have NVRAM for this, and yet other's put it
> into the PCI ROM.

Well, I specifically said "isn't already programmed in the hardware".  I wasn't talking about just the NIC.  

> Some platforms that have real OF device trees often do not put the
> permanent MAC address into the EEPROM or NVRAM even if it is
> customary to do so on a particular device.  The MAC has to be
> obtained from the OF device tree.

Sorry, you're not answering my question.  I asked what do drivers do when the MAC address is not in the OF tree, and it is not programmed in hardware (any hardware).

-- 
Timur Tabi
Linux kernel developer at Freescale
