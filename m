Return-Path: <linux-kernel-owner+w=401wt.eu-S1030259AbXBGAIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbXBGAIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030261AbXBGAIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:08:49 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:38209 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030259AbXBGAIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:08:48 -0500
Subject: 2.6.20 [drm:i915_wait_irq] *ERROR*
From: Lionel Landwerlin <landwer@free.fr>
Reply-To: landwer@free.fr
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 07 Feb 2007 01:08:46 +0100
Message-Id: <1170806926.5669.6.camel@cocoduo>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm running a 2.6.20 kernel on my macbook. When running an openGL
application, if the opengl window's region is moved somewhere outside
the screen limits, then keyboard locks, I can only move the mouse,
nothing response. I can only reboot the box by pressing the power button
5 seconds. /var/log/syslog contains that :

kernel: [drm:i915_wait_irq] *ERROR* i915_wait_irq: EBUSY -- rec: 730561 emitted: 730570

The macbook uses an intel card :

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)

Xorg version 7.1.1

-- 
Lionel Landwerlin <landwer@free.fr>

