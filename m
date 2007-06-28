Return-Path: <linux-kernel-owner+w=401wt.eu-S1765060AbXF1S03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765060AbXF1S03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759616AbXF1S0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:26:22 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:35627 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756936AbXF1S0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:26:21 -0400
In-Reply-To: <200706281647.57408.arnd@arndb.de>
References: <11829333481420-git-send-email-wei.zhang@freescale.com> <200706272256.16418.arnd@arndb.de> <46B96294322F7D458F9648B60E15112C6F31B2@zch01exm26.fsl.freescale.net> <200706281647.57408.arnd@arndb.de>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <f898cd2f2d13e5bbdbc6306781257f2e@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: paulus@samba.org, "Zhang Wei-r63237" <Wei.Zhang@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 3/5 v2] Add the platform device support with RapidIO to MPC8641HPCN platform.
Date: Thu, 28 Jun 2007 20:26:13 +0200
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Of course, looking at the device tree, rapidio is a device, not a bus,
> because it does not have a device_type and it does not have any 
> children
> of its own.

It's a device _of course_, but it's also a bus parent, since
it has a "#address-cells" not equal to zero (and, if this used
real OF, it would have decode-unit and encode-unit methods).
A quite empty bus perhaps heh (in this device tree, anyway).


Segher

