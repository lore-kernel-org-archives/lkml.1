Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZHNLZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZHNLZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbZHNLZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:25:41 -0400
Received: from mailout07.t-online.de ([194.25.134.83]:34374 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082AbZHNLZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:25:41 -0400
X-Greylist: delayed 2771 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Aug 2009 07:25:40 EDT
Message-ID: <4A853ED8.9030800@t-online.de>
Date: Fri, 14 Aug 2009 12:39:20 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: airlied@linux.ie
CC: linux-kernel@vger.kernel.org
Subject: drm / i915 performance problems
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-ID: GE1g9sZrohtppRKQnWDBGUswpxazpLQ9Hp9WNFg-8Ed5z4VvR7eHGy1d2H8F-QUQuG
X-TOI-MSGID: 9f396770-4a50-4e9d-ac5b-9c32ae22f081
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David!

My current system is based on openSuSE 10.2, kernel 2.6.22.6 is used.
As support for that distribution is discontinued, I had a look at
openSuSE 11.1
and tried some of the new kernels. I found serious  performance regressions
using the current kernels

First a short descrition of the relevant hardware:

mainboard: Aopen i915Gmm-hfs,
RAM: 2 GB
cpu: Pentium M  1.86GHz.
video: built in i915GM
00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML
Express Processor to DRAM Controller (rev 04)
00:02.0 VGA compatible controller: Intel Corporation Mobile
915GM/GMS/910GML Express Graphics Controller (rev 04) (prog-if 00 [VGA])
00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML
Express Graphics Controller (rev 04)

Test results:

glxgears: 1045 fps / 30% cpu usage (opensuse 10.2, kernel 2.6.22.6,
smooth desktop and glxgears operation)
glxgears: 925 fps / 35% cpu usage (opensuse 11.1, kernel 2.6.22.6,
smooth desktop and glxgears operation)
glxgears: 900 fps / 45% cpu usage (opensuse 11.1, kernel 2.6.27.29,
smooth desktop and glxgears operation)

glxgears: 210 fps / 8% cpu usage (opensuse 11.1, kernel 2.6.31-rc6,
Tiled buffers, jerky desktop and glxgears operation)
glxgears: 230 fps / 8% cpu usage (opensuse 11.1, kernel 2.6.31-rc6,
Tiling disabled, jerky desktop and glxgears operation)

glxgears: 280 fps / 100% cpu usage (opensuse 11.1, kernel 2.6.31-rc6,
DRI disabled in kernel, smooth desktop and glxgears operation)
 
With "jerky operation" in the table above I want to express, that
desktop and glxgears drawing operation seems to happen in
several bursts a second. Because of that the desktop performance is
annoying enough to be unusable.

Xorg.0.log tells me: "Failed to set tiling on [front|back|depth] buffer:
Invalid argument". As disabling tiling in the older kernels
results in similar performance drops, I believe that the inability to
use tiled buffers is responsible for the low glxgears fps numbers.

Any ideas how to solve that problem?

cu,
 Knut
