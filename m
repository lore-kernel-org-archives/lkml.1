Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0AOESS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 23:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206Ab0AOESR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 23:18:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:6433 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab0AOESQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 23:18:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=PpPTp0gOYAFF7qNiu7UP0N813jG+HIPnNKXtOTKOKArv2ixw9+tYPsYNWijJbYz0gL
         yiVWkHKbjmrY3miWe+0BRY1H2nOOGfV7RIQ//Ng4S6gCTXF5fQCcD93qrnO0odkX1wWy
         BQAp4P+Jp/sm5R6+xOO4YzpLye1FCFwvzFiXw=
MIME-Version: 1.0
Date: Thu, 14 Jan 2010 23:18:14 -0500
Message-ID: <a44ae5cd1001142018k1f6b741buf560edbda0ca6e33@mail.gmail.com>
Subject: 2.6.33-rc4-git1 -- [drm:i915_gem_execbuffer] *ERROR* 
	i915_gem_do_execbuffer returns -512
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        DRI for Linux <dri-devel@lists.sourceforge.net>,
        David Airlie <airlied@linux.ie>, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just hit this with 2.6.33-rc4-git1 and DRI modesetting enabled.  I
don't know what event triggered the error.  I had resumed from suspend
a long time before the error appeared in my dmesg output:

[ 8505.847430] [drm:i915_gem_execbuffer] *ERROR*
i915_gem_do_execbuffer returns -512

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME
Express Integrated Graphics Controller (rev 03)
	Subsystem: ASUSTeK Computer Inc. Device 8340
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f7f00000 (32-bit, non-prefetchable) [size=512K]
	Region 1: I/O ports at dc00 [size=8]
	Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 3: Memory at f7ec0000 (32-bit, non-prefetchable) [size=256K]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: i915

CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_VGA_ARB=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y
