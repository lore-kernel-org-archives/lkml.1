Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYKCQWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYKCQWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 11:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYKCQWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 11:22:41 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:52447 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbYKCQWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 11:22:40 -0500
X-Greylist: delayed 3080 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2008 11:22:40 EST
Date: Mon, 3 Nov 2008 16:31:18 +0100
To: linux-kernel@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
       linux-usb-devel@lists.sourceforge.net
Subject: usb device not showing up
Message-ID: <20081103153118.GA27552@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

(please Cc)

I have the following problem with a disappearing or better not appearing
device: My Sony Vaio VGN-Z11 laptop contains a HSDPA modem:
	USB: Bus 004 Device 002: ID 0af0:6911 Option
which is very nicely supported by the hso kernel module (when using the
latest hso patches for the BUG).

Interestingly this device does disappear if I cold boot into linux.

So:
- First booting Vista, then RE-booting (not turning it off in the
  meantime) into linux gives me that device and everything works.

- Cold-booting into Linux and the device does not show up.


There were some suggestions I found on the internet that I should echo 1
to /sys/devices/platform/sony-acpi/wwanpower, which I could do and the
value could be read from it again, but it didn't make the USB device
show up.

Is there any way to activate this device other than always going into
Vista first?

Is there a way to save some settings of this device after a reboot (so
in a functional state) and restoring that later on?

I am currently running 2.6.28-rc3 with Mattia Dongili's latest sony-acpi
patches sent to the acpi ML, but had the same problems with -rc2 and
2.6.27, without additional patches.

Please let me know if I can provide further information, I will also
happily hack my kernel to get this device working out of the box.

Thanks a lot and all the best

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
WETWANG (n.)
A moist penis.
			--- Douglas Adams, The Meaning of Liff
