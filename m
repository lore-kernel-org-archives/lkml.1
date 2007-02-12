Return-Path: <linux-kernel-owner+w=401wt.eu-S964892AbXBLNVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892AbXBLNVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964905AbXBLNVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:21:17 -0500
Received: from hermes.domdv.de ([193.102.202.1]:2199 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964892AbXBLNVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:21:16 -0500
Message-ID: <45D069C3.2020406@domdv.de>
Date: Mon, 12 Feb 2007 14:21:07 +0100
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: Brad Campbell <brad@wasp.net.au>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver - one more
References: <113489.35158.qm@web36703.mail.mud.yahoo.com> <45CDC22B.6040408@drzeus.cx> <45CEB1C9.5010103@wasp.net.au> <45CF3904.5070401@drzeus.cx> <45CF3CA3.1010704@wasp.net.au> <45CF5AB0.6080309@drzeus.cx> <45CF6F64.60500@wasp.net.au>
In-Reply-To: <45CF6F64.60500@wasp.net.au>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brad Campbell wrote:
> Alex, it's still hit and miss getting this card detected. I had to
> insert/remove the card over 10 times with random driver load/unloads
> until it created the device entries..

And for me it's still worse, no matter what I try with 2.6.20:

speedy:~ # find /sys/devices | grep tifm
/sys/devices/pci0000:00/0000:00:14.4/0000:03:09.3/tifm_sd0:3
/sys/devices/pci0000:00/0000:00:14.4/0000:03:09.3/tifm_sd0:3/mmc_host:mmc0
/sys/devices/pci0000:00/0000:00:14.4/0000:03:09.3/tifm_sd0:3/driver
/sys/devices/pci0000:00/0000:00:14.4/0000:03:09.3/tifm_sd0:3/bus
/sys/devices/pci0000:00/0000:00:14.4/0000:03:09.3/tifm_sd0:3/subsystem
/sys/devices/pci0000:00/0000:00:14.4/0000:03:09.3/tifm_sd0:3/power
/sys/devices/pci0000:00/0000:00:14.4/0000:03:09.3/tifm_sd0:3/power/wakeup
/sys/devices/pci0000:00/0000:00:14.4/0000:03:09.3/tifm_sd0:3/uevent

speedy:~ # find /sys/block | grep mmc
speedy:~ #

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
