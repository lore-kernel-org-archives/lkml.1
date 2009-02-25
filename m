Return-Path: <linux-kernel-owner+w=401wt.eu-S1760313AbZBYHX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313AbZBYHX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZBYHXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:23:47 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:37718 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbZBYHXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:23:47 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 02:23:46 EST
X-Originating-Ip: 216.16.235.2
Date: Wed, 25 Feb 2009 02:18:28 -0500
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org
Subject: Building a kernel without /lib/firmware
Message-ID: <20090225071828.GA27279@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=-16.8, required 5,
	autolearn=not spam, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: cdfrey@foursquare.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed another thread mentioning that it is possible to ignore the
firmware that comes with the kernel.  Unfortunately, the current build
process doesn't make this easy.

I'm trying to build 2.6.28.7, and I have the following firmware related
config:

[cdfrey@frontdesk linux]$ grep -i firmware .config
CONFIG_PREVENT_FIRMWARE_BUILD=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_SND_WAVEFRONT_FIRMWARE_IN_KERNEL is not set
# Firmware Drivers
# CONFIG_FIRMWARE_MEMMAP is not set

[cdfrey@frontdesk linux]$ grep -i fw_loader .config
CONFIG_FW_LOADER=m

What else do I need to turn off in order for a 'make modules_install' to
skip the firmware_install?

Thanks,
- Chris

