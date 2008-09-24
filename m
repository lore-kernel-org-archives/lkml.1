Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbYIXUBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbYIXUBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYIXUB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:01:29 -0400
Received: from eazy.amigager.de ([213.239.192.238]:48695 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYIXUB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:01:29 -0400
Date: Wed, 24 Sep 2008 22:01:27 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Differend udev names with different kernels
Message-ID: <20080924200127.GA2452@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-hotplug@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

what's the intention of /dev/disk/by-id/?

My firewire hard disk seems to have different names with different
kernels.

With 2.6.26.3, it's name is
/dev/disk/by-id/ieee1394-0030e001e0006585:00043c:0000.

With someting after 2.6.27-rc7, merged with Arjan's fastboot branch,
the disk has the same name.

With 2.6.27-rc7, it is called
/dev/disk/by-id/scsi-1WDC_WD10EACS-00D6B0_WD-WCAU41668315.

One major config difference is that 2.6.26.3 has CONFIG_FIREWIRE and
CONFIG_FIREWIRE_SBP2 set to "m", whereas the 2.6.27 kernels have set
them to "y". But that doesn't explain the difference between both
2.6.27-rc kernels.

Shouldn't these names be somewhat constant? Otherwise they would be
totally useless.

Regards,
Tino
