Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbZCaNcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbZCaNcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbZCaNcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:32:14 -0400
Received: from mga05.intel.com ([192.55.52.89]:48558 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759421AbZCaNcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:32:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="443612204"
Date: Tue, 31 Mar 2009 15:34:17 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tobias Klauser <tklauser@distanz.ch>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Huang Weiyi <weiyi.huang@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] MFD pull request
Message-ID: <20090331123021.GB4612@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20090331113648.GA4612@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331113648.GA4612@sortiz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to cc lkml...sorry about that.

On Tue, Mar 31, 2009 at 01:36:48PM +0200, Samuel Ortiz wrote:
> Hi Linus,
> 
> Here are a few mfd updates for the rc1. Nothing outstanding, just the regular
> WM835x updates and some DS1WM and PASIC3 changes.
> This is my last pull request from git.o-hand.com. I moved the mfd tree to
> git.kernel.org, as specified in the MAINTAINERS changes.
> 
> Thanks in advance for pullling.
> 
> The following changes since commit 15f7176eb1cccec0a332541285ee752b935c1c85:
>   Linus Torvalds (1):
>         Merge git://git.kernel.org/.../davem/net-2.6
> 
> are available in the git repository at:
> 
>   git://git.o-hand.com/linux-mfd for-next
> 
> Huang Weiyi (1):
>       mfd: remove duplicated #include from pcf50633
> 
> Mark Brown (3):
>       mfd: Use bulk read to fill WM8350 register cache
>       mfd: Support active high IRQs on WM835x
>       mfd: Use the value of the final spin when reading the AUXADC
> 
> Philipp Zabel (6):
>       mfd: convert DS1WM to use MFD core
>       mfd: convert PASIC3 to use MFD core
>       pxa/magician: remove deprecated .bus_shift from PASIC3 platform_data
>       mfd: remove unused PASIC3 bus_shift field
>       mfd: remove DS1WM clock handling
>       mfd: PASIC3: supply clock_rate to DS1WM via driver_data
> 
> Samuel Ortiz (2):
>       mfd: fix MAINTAINERS entry
>       mfd: fix da903x warning
> 
> Tobias Klauser (1):
>       mfd: Storage class should be before const qualifier
> 
>  MAINTAINERS                     |    3 +-
>  arch/arm/mach-pxa/magician.c    |    1 -
>  drivers/mfd/Kconfig             |    1 +
>  drivers/mfd/da903x.c            |    2 +-
>  drivers/mfd/htc-pasic3.c        |  169 ++++++++++++++++-----------------------
>  drivers/mfd/pcf50633-core.c     |    1 -
>  drivers/mfd/t7l66xb.c           |    4 +-
>  drivers/mfd/tc6393xb.c          |    2 +-
>  drivers/mfd/twl4030-irq.c       |    2 +-
>  drivers/mfd/wm8350-core.c       |   39 +++++++---
>  drivers/w1/masters/ds1wm.c      |   58 ++++++-------
>  include/linux/ds1wm.h           |   12 ---
>  include/linux/mfd/ds1wm.h       |    6 ++
>  include/linux/mfd/htc-pasic3.h  |    1 -
>  include/linux/mfd/wm8350/core.h |    2 +
>  15 files changed, 139 insertions(+), 164 deletions(-)
>  delete mode 100644 include/linux/ds1wm.h
>  create mode 100644 include/linux/mfd/ds1wm.h
> 
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
