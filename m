Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbYCATf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbYCATf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYCATfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:35:16 -0500
Received: from the.earth.li ([217.147.81.2]:53665 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbYCATfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:35:14 -0500
Date: Sat, 1 Mar 2008 19:35:11 +0000
From: Jonathan McDowell <noodles@earth.li>
To: xorg-driver-ati@lists.x.org, linux-kernel@vger.kernel.org
Subject: 2.6.25-rc3 + RS690 + DRM + xf86-video-ati hang
Message-ID: <20080301193511.GP9009@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I enable CONFIG_DRM_RADEON under 2.6.25-rc3 then starting up
X using the xf86-video-ati driver (6.8.0 or latest git) causes the
machine to become unresponsive; while it still pings and will accept
incoming connections they never actually complete and it's not possible
to login over a serial console (the actual video console doesn't display
anything and the monitor reports a loss of sync).

Disabling the kernel DRM option results in X running successfully.
Likewise 2.6.24 works fine with DRM enabled, presumably because the
support for the RS690 was only added in 2.6.25-rc

The last messages from the kernel before it becomes unresponsive are:

[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] writeback test succeeded in 1 usecs

The motherboard in question is an ASUS M2A-VM HDMI, with the analog VGA
output being used. The machine is running an AMD64 with Debian unstable.
I have put the output of lspci, a non drm Xorg.log and a drm Xorg.log
at:

http://the.earth.li/~noodles/xorg-ati-drm/lspci
http://the.earth.li/~noodles/xorg-ati-drm/Xorg.0.log-nodrm
http://the.earth.li/~noodles/xorg-ati-drm/Xorg.0.log-drm

If I can provide any more useful information please let me know.

J.

-- 
 I get the feeling that I've been  |  .''`.  Debian GNU/Linux Developer
             cheated.              | : :' :  Happy to accept PGP signed
                                   | `. `'   or encrypted mail - RSA +
                                   |   `-    DSA keys on the keyservers.
