Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbZIIBFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbZIIBFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZIIBFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:05:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:57420 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZIIBFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:05:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185493540"
Subject: Re: [Intel-gfx] Regression DRM/i915/KMS: VGA connector unusable
	after 2.6.31-rc8-git1, DVI connector ok
From: ykzhao <yakui.zhao@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Knut Petersen <Knut_Petersen@t-online.de>
Cc: Knut Petersen <Knut_Petersen@t-online.de>,
       "airlied@linux.ie" <airlied@linux.ie>,
       Linus Torvalds <torvalds@osdl.org>,
       "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090908152636.701feffb@jbarnes-g45>
References: <4AA6D858.6040505@t-online.de>
	 <20090908152636.701feffb@jbarnes-g45>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Wed, 09 Sep 2009 09:05:33 +0800
Message-Id: <1252458334.3609.146.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 06:26 +0800, Jesse Barnes wrote:
> cc'ing the intel-gfx list.
> 
> On Wed, 09 Sep 2009 00:19:04 +0200
> Knut Petersen <Knut_Petersen@t-online.de> wrote:
> 
> > Hi everybody!
> > 
> > During the release cycle of the 2.6.31-rc* kernels KMS started to work
> > on my computer.
> > 
> > Booting with a monitor attached to both the VAG and the DVI
> > connectors, kernel 2.6.31-rc8-git1
> > detects both monitors correctly and sets the native video mode.
> > 
> > Booting the same configuration with kernel 2.6.31-rc8-git2 ...
> > -rc9-git1 gives a different result:
> > the DVI-attached monitor is still working perfectly, the VGA-attached
> > monitor does not detect a
> > valid video signal and switches off.
> > 
> > Hardware: AOpen i915GMm-hfs,  Pentium-M 1.86 MHz,  2GB RAM
> > The Aopen i915GMm-hfs is a  desktop board with a mobile Chipset:
> > 
> > 00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML
> > Express Processor to DRAM Controller (rev 04)
> > 00:02.0 VGA compatible controller: Intel Corporation Mobile
> > 915GM/GMS/910GML Express Graphics Controller (rev 04)
> > 00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML
> > Express Graphics Controller (rev 04)
> > 
> > Config: AGP/DRM/I915 all compiled into kernel, KMS enabled.
> > 
> > Log_Broken contains the result of "cat boot.msg | grep -i drm" of a
> > boot with 2.6.31-rc8-git2,
> > Log_OK contains the result of "cat boot.msg | grep -i drm" of a boot
> > with 2.6.31-rc8-git1
> > 
> > As a black monitor is not a nice gift I think this should be fixed
> > before the final release of 2.6.31.
Will you please try the latest git tree and see whether the issue can
still be reproduced?
Thanks.
> > 
> > cu,
> >  Knut
> 
> 

