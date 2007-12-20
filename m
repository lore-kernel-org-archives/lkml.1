Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbXLTFQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbXLTFQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 00:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbXLTFQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 00:16:21 -0500
Received: from ozlabs.org ([203.10.76.45]:36256 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbXLTFQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 00:16:21 -0500
Date: Thu, 20 Dec 2007 16:16:18 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Convert PowerPC MPC i2c to of_platform_driver from
	platform_driver
Message-ID: <20071220051618.GB29058@localhost.localdomain>
Mail-Followup-To: Jon Smirl <jonsmirl@gmail.com>, i2c@lm-sensors.org,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20071220044136.20091.70984.stgit@terra.home> <20071220044144.20091.35917.stgit@terra.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220044144.20091.35917.stgit@terra.home>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 11:41:44PM -0500, Jon Smirl wrote:
> Convert MPC i2c driver from being a platform_driver to an open
> firmware version. Error returns were improved. Routine names were
> changed from fsl_ to mpc_ to make them match the file name.

In discussions BenH and I have had, we've actually concluded that
moving this from platform drivers to of_platform drives is not
actually a good idea.

In fact we're planning to move away from of_platform devices and
drivers and instead develop a framework for instantiating platform
devices or i2c devices or whatever devices from the device tree nodes.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
