Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZHNNUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZHNNUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZHNNUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:20:22 -0400
Received: from gvgeloven01.mjopr.nl ([212.83.231.34]:59468 "EHLO mjopr.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbZHNNUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:20:21 -0400
X-Greylist: delayed 1390 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Aug 2009 09:20:21 EDT
Message-ID: <4A855F5D.1010502@users.sourceforge.net>
Date: Fri, 14 Aug 2009 14:58:05 +0200
From: Pander <pander@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC] charger: Offer kernel build that disables disks, screen, etc.
 and lets laptop serve as charger for USB/FireWire devices
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Consider situations where normal power outlets are not available, e.g.
when travelling in remote areas or in an air plane or train, but you do
need to charge USB/FireWire devices like a mobile telephone, camera,
PDA, etc. It would be efficient to boot your laptop with a special
kernel that turns it into a charger.

Some laptops already offer this feature, however the majority of laptops
donot. A suspended laptop can offer this too, but please consider
situation orplaces where power is so scarce that normally booting a
laptop in order tocharge another device is undesirable in terms of being
efficient with theenergy stored in the battery or that it is not allowed
to activate RF devicesas is in an air plane.

Normal boot will cause that a lot of power will be consumed by the
disks,screen, CPUs, RF devices, fans, all LEDs (except the one
indicating the deviceis switched on), etc. while you are only interested
in power being available at the USB/FireWire ports.

This can be achieved by building a special kernel that will shut down
all hardware that is not needed for offering power on the before
mentioned ports. Perhaps this can be achieved by kernel configuration
alone or it might require a minimal of functionality to put a laptop
into such a charging state.

Normally, systems automatically shut down before the battery is drained
100%. This kernel will allow you to drain all the entire battery.

The resulting kernel can be installed and made available in a similar
way as the memtest kernel and can be incorporated by installers of
GNU/Linux distributions.

Implementing this idea will allow for highly energy efficient recharging
of devices like telephones, cameras and other mobile devices via your
laptop.

Regards,

Pander

