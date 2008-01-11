Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbYAKI4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbYAKI4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbYAKI4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:56:46 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:1424 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758096AbYAKI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:56:45 -0500
Date: Fri, 11 Jan 2008 09:56:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH 0/5] Version 17,  series to add device tree naming
 to i2c
Message-ID: <20080111095638.775670ed@hyperion.delvare>
In-Reply-To: <20071220044136.20091.70984.stgit@terra.home>
References: <20071220044136.20091.70984.stgit@terra.home>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Wed, 19 Dec 2007 23:41:36 -0500, Jon Smirl wrote:
> Since copying i2c-mpc.c to maintain support for the ppc architecture seems to be an issue; instead rework i2c-mpc.c to use CONFIG_PPC_MERGE #ifdefs to support both the ppc and powerpc architecture. When ppc is deleted in six months these #ifdefs will need to be removed.
> 
> Another rework of the i2c for powerpc device tree patch. This version implements standard alias naming only on the powerpc platform and only for the device tree names. The old naming mechanism of i2c_client.name,driver_name is left in place and not changed for non-powerpc platforms. This patch is fully capable of dynamically loading the i2c modules. You can modprobe in the i2c-mpc driver and the i2c modules described in the device tree will be automatically loaded. Modules also work if compiled in.
> 
> The follow on patch to module-init-tools is also needed since the i2c subsystem has never implemented dynamic loading.
> 
> The following series implements standard linux module aliasing for i2c modules on arch=powerpc. It then converts the mpc i2c driver from being a platform driver to an open firmware one. I2C device names are picked up from the device tree. Module aliasing is used to translate from device tree names into to linux kernel names. Several i2c drivers are updated to use the new aliasing. 

Now that I have read all the previous versions of this patch series
and, more importantly, all objections that were raised on the way, I
can start reviewing the latest iteration of your patches. I'll also do
some testing, although I have no powerpc stuff here, but at least I
want to make sure that there are no regressions introduced by your
patches on x86.

-- 
Jean Delvare
