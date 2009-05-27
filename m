Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbZE0U0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbZE0U0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933242AbZE0UZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:25:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57318
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934002AbZE0UZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:25:54 -0400
Date: Wed, 27 May 2009 13:25:53 -0700 (PDT)
Message-Id: <20090527.132553.40558501.davem@davemloft.net>
To: timur@freescale.com
Cc: scottwood@freescale.com, rmk+lkml@arm.linux.org.uk, jacmet@sunsite.dk,
       r.schwebel@pengutronix.de, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       yuan-bo.ye@motorola.com
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A1D9A66.5020002@freescale.com>
References: <20090527192909.GA32398@flint.arm.linux.org.uk>
	<4A1D9A1E.80603@freescale.com>
	<4A1D9A66.5020002@freescale.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timur Tabi <timur@freescale.com>
Date: Wed, 27 May 2009 14:54:14 -0500

> How does a Linux driver normally get a MAC address if it's not
> passed via the device tree and it isn't already programmed in the
> hardware?  Is there some file in /etc that stores these things?

It depends.  Some devices have EEPROM's that store the permanently
assigned MAC address, some have NVRAM for this, and yet other's put it
into the PCI ROM.

Some platforms that have real OF device trees often do not put the
permanent MAC address into the EEPROM or NVRAM even if it is
customary to do so on a particular device.  The MAC has to be
obtained from the OF device tree.
