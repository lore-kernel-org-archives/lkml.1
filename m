Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbXLTGEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbXLTGEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 01:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbXLTGEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 01:04:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:58894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbXLTGEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 01:04:22 -0500
From: Stefan Roese <sr@denx.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/5] Convert PowerPC MPC i2c to of_platform_driver from platform_driver
Date: Thu, 20 Dec 2007 07:04:16 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: David Gibson <david@gibson.dropbear.id.au>, Jon Smirl <jonsmirl@gmail.com>,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org
References: <20071220044136.20091.70984.stgit@terra.home> <20071220044144.20091.35917.stgit@terra.home> <20071220051618.GB29058@localhost.localdomain>
In-Reply-To: <20071220051618.GB29058@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200704.17309.sr@denx.de>
X-Provags-ID: V01U2FsdGVkX1/5NMkZc0wy/o7RIwIByP9ajIn5VEdSWzeZKgM
 Z+h1KLWaHR4qsgUc2Sq11MqyRthCNrvufRmvnzyGdhmjHiIQjn
 BJMaJl/VjUZfBSqs7w49Q9A/YEjC86P
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007, David Gibson wrote:
> On Wed, Dec 19, 2007 at 11:41:44PM -0500, Jon Smirl wrote:
> > Convert MPC i2c driver from being a platform_driver to an open
> > firmware version. Error returns were improved. Routine names were
> > changed from fsl_ to mpc_ to make them match the file name.
>
> In discussions BenH and I have had, we've actually concluded that
> moving this from platform drivers to of_platform drives is not
> actually a good idea.
>
> In fact we're planning to move away from of_platform devices and
> drivers and instead develop a framework for instantiating platform
> devices or i2c devices or whatever devices from the device tree nodes.

Now that is interesting news. I like this idea.

But what should be done to support the still missing devices in the 4xx 
arch/powerpc tree, like I2C, NAND etc.? Should we wait with those driver till 
this framework is available?

Thanks.

Cheers,
Stefan
