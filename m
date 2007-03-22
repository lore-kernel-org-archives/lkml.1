Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbXCVTfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbXCVTfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933166AbXCVTfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:35:12 -0400
Received: from mail.darkstartechnologies.net ([83.142.224.43]:55822 "EHLO
	mail.dst-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbXCVTfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:35:10 -0400
X-Greylist: delayed 1667 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2007 15:35:10 EDT
From: Witold Krecicki <wpk@dst-labs.com>
Organization: SCMP
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc4-git6 Console freezes
Date: Thu, 22 Mar 2007 20:05:06 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703222005.06115.wpk@dst-labs.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1. Hardware: HP Pavilion DV6150eu, AMD Turion 64 X2 TL-52, NVidia MCP51 
chipset, GeForce Go 7200
2. Problem: 
Console 'freezes' in random moments, showing no underscore cursor, nor GPM 
mouse cursor, it's not responding on network too. System works perfectly fine 
in graphics mode (with propertiary NVidia module loaded, those freezes are 
happening with and without it, so it's not the problem). Appeared on earlier 
kernels (for sure on 2.6.20-rc6, AFAIR I've tested 2.6.18 too), but it wasn't 
so annoying as it usually got to run KDM before freezing (not always) - on 
2.6.21-rc4-git6 it has freezed in:

[    0.000000] Linux version 2.6.21-rc4-git6 (wpk@hippie) (gcc version 4.2.0 
20070307 (prerelease) (PLD-Linux)) #2 SMP Thu Mar 22 19:09:09 CET 2007
[    0.000000] Command line: root=/dev/dm-0 resume2=swap:/dev/dm-0:0xd8098
(...)
[   12.596158] PCI: Found 0000:00:0d.0 [10de/0265] 000101 00
[   12.596176] 0000:00:0d.0: cannot adjust BAR0 (not I/O) <- this moment in ~ 
4/6 boot-ups
[   12.596234] 0000:00:0d.0: cannot adjust BAR1 (not I/O) 
[   12.596291] 0000:00:0d.0: cannot adjust BAR2 (not I/O) <- and one time here
[   12.596348] 0000:00:0d.0: cannot adjust BAR3 (not I/O)

After few tries, it boots up perfectly, passing that moment. 
Mentioned device is 
00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev f1)
Though it might not be a problem with the device (as it happened before, in 
different moments, on earlier kernels).

