Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbZAAFe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbZAAFe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 00:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbZAAFes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 00:34:48 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:56824 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbZAAFer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 00:34:47 -0500
X-Greylist: delayed 2355 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jan 2009 00:34:47 EST
Message-ID: <495C4CC0.1040006@blueyonder.co.uk>
Date: Thu, 01 Jan 2009 04:55:28 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.28-git forcedeth dead interface and nvidia problems 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28 works fine. 2.6.28-git1/3 only eth0 nVidia Corporation MCP55
Ethernet (rev a2) connected, using forcedeth driver, no light from the
card/switch. Checking ifconfig and route -n says the network is
correctly configured. In order to get the network back, I have to power
off/on and boot up 2.6.28. It seems to leave a permanent condition, so a
reboot to 2.6.28 does not get it working again.
Except for the additional config changes/options presented in
2.6.28-git, the kernels are configured the same, no network config
changes made.
Using openSUSE 11.2 Alpha0 x86_64 dual-core 6000+.

JUST FOR INFORMATION, but I'd be surprised if the two problems aren't
linked in some way.
=====================
The NVidia driver 180.18 works fine with 2.6.28, but fails with
2.6.28-git. The module builds and installs fine, Xorg.0.log says:-
(II) NVIDIA(0): Initialized GPU GART.
(II) NVIDIA(0): Setting mode "1280x1024"
(EE) NVIDIA(0): Failed to allocate video memory
(EE) NVIDIA(0):  *** Aborting ***

Fatal server error:
AddScreen/ScreenInit failed for driver 0

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

