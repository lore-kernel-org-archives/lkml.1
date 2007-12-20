Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbXLTFzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbXLTFzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 00:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbXLTFy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 00:54:58 -0500
Received: from lixom.net ([66.141.50.11]:38439 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbXLTFy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 00:54:58 -0500
Date: Thu, 20 Dec 2007 00:01:19 -0600
From: Olof Johansson <olof@lixom.net>
To: Jon Smirl <jonsmirl@gmail.com>, i2c@lm-sensors.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Convert PowerPC MPC i2c to of_platform_driver from
	platform_driver
Message-ID: <20071220060119.GA8456@lixom.net>
References: <20071220044136.20091.70984.stgit@terra.home> <20071220044144.20091.35917.stgit@terra.home> <20071220051618.GB29058@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220051618.GB29058@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 04:16:18PM +1100, David Gibson wrote:
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

There's been talk about that for a long time. Whenever that framework
is done, all the other drivers that have been converted (or written)
must/can be converted back as well.

Meanwhile, this should go in so those of us who can make use of the
other improvements the series brings can make use of them.


Thanks,

Olof
