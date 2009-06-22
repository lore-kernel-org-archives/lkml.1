Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZFVU0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZFVU0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZFVU0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:26:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZFVU0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:26:38 -0400
Date: Mon, 22 Jun 2009 16:20:05 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jerome Glisse <jglisse@redhat.com>,
       Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [git pull] drm: previous pull req + 1.
Message-ID: <20090622192005.GA3000@ghostprotocols.net>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie> <4A3DABE1.50309@mit.edu> <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie> <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain> <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain> <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com> <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain> <cb0375e10906211414j390fc590y4331896bddda9c0d@mail.gmail.com> <cb0375e10906211705q382f5211lf09e39ff637c1c0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0375e10906211705q382f5211lf09e39ff637c1c0d@mail.gmail.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jun 21, 2009 at 08:05:36PM -0400, Andrew Lutomirski escreveu:
> 
> David -- there are still plenty of bugs.  The kernel gets my monitor's
> resolution wrong (X reads it off DDC correctly but I have to use
> xrandr to force the resolution).

No crashes here, but I was able to use an external Samsung SyncMaster
226BW at 1680x1050 and now this resolution doesn't even appear as one of
the possible resolutions on xrandr :-(

F11, uptodate:

xorg-x11-drv-intel-2.7.0-7.fc11.x86_64

Thinkpad T60W

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)

dmesg lines related: That DAC-6 line should be setting it to 1680x1050
as has been till I switched to this new kernel:

ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
<SNIP>
allocated 1680x1050 fb: 0x007df000, bo ffff880037c3a780
Console: switching to colour frame buffer device 160x64
[drm] DAC-6: set mode 1280x1024 b <====================================
<SNIP>
[drm] LVDS-8: set mode 1680x1050 21
fb0: inteldrmfb frame buffer device
registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

- Arnaldo
