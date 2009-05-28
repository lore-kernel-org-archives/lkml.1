Return-Path: <linux-kernel-owner+w=401wt.eu-S1751534AbZE1E1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbZE1E1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 00:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZE1E1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 00:27:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39804
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbZE1E1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 00:27:31 -0400
Date: Wed, 27 May 2009 21:27:30 -0700 (PDT)
Message-Id: <20090527.212730.183576278.davem@davemloft.net>
To: david@gibson.dropbear.id.au
Cc: linux@arm.linux.org.uk, jonsmirl@gmail.com, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, timur@freescale.com,
       scottwood@freescale.com, yuan-bo.ye@motorola.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090528025258.GB1464@yookeroo.seuss>
References: <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com>
	<20090527192116.GA31110@n2100.arm.linux.org.uk>
	<20090528025258.GB1464@yookeroo.seuss>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Gibson <david@gibson.dropbear.id.au>
Date: Thu, 28 May 2009 12:52:58 +1000

> The of_platform bus model is conceptually completely broken, but in
> practice only slightly broken for all common cases.

The fact that every single SBUS and EBUS driver for sparc is now an
of_platform driver, and the fact that as a further result joint
SBUS/PCI drivers are now almost completely unified, speaks volumes to
the fact that it is not broken.

Yes, you'll have some non-shared probing code, one to fetch the
resources from PCI/platform_device/whatever and one for of_device.

But, I say big deal.

The rest remains entirely unified, even the DMA calls are all the
same in unified SBUS/EBUS/PCI device drivers.  It just works.
