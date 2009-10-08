Return-Path: <linux-kernel-owner+w=401wt.eu-S933720AbZJHVbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbZJHVbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933656AbZJHVbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:31:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:44316 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535AbZJHVbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:31:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y7RbhUIOCZmpH27KCuxESS5p6tyOTywv2IpszOsZg6+3NTGie7u+7SicidTa7rfeMk
         YYtT5bRt7YK/uPLWfrvjgKJzcKD1USapbwmCoy/Wx8kq5xNddREsC4/Xpv+oNn9LX2fm
         rfM4ShZqhZENBhGBYQukD0LXDsoiyOVD960dk=
MIME-Version: 1.0
In-Reply-To: <20091007185112.GJ7899@atomide.com>
References: <20091007185112.GJ7899@atomide.com>
Date: Fri, 9 Oct 2009 00:29:52 +0300
Message-ID: <94a0d4530910081429m7ad88b43q38245109f3252078@mail.gmail.com>
Subject: Re: [GIT PULL] omap fixes for v2.6.32-rc3
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 9:51 PM, Tony Lindgren <tony@atomide.com> wrote:
> Linus,
>
> Please pull omap fixes from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus
>
> Regards,
>
> Tony
>
>
> The following changes since commit 374576a8b6f865022c0fd1ca62396889b23d66dd:
>  Linus Torvalds (1):
>        Linux 2.6.32-rc3
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus
>
> Artem Bityutskiy (1):
>      OMAP3: PM: introduce a new powerdomain walk helper
>
> Daniel Walker (1):
>      omap: iovmm: Add missing mutex_unlock
>
> Hiroshi DOYU (1):
>      omap: iovmm: Fix incorrect spelling
>
> Jon Hunter (1):
>      OMAP3: PM: Prevent hang in prcm_interrupt_handler
>
> Kevin Hilman (1):
>      OMAP3: PM: Enable GPIO module-level wakeups
>
> Paul Walmsley (2):
>      OMAP3: PM: PRCM interrupt: check MPUGRPSEL register
>      OMAP3: PM: PRCM interrupt: only handle selected PRCM interrupts
>
> Rajendra Nayak (1):
>      omap: Lock DPLL5 at boot
>
> Sergio Aguirre (1):
>      omapfb: Condition mutex acquisition
>
> Tommi Rantala (2):
>      omapfb: Blizzard: fix pointer to be const
>      omapfb: Blizzard: constify register address tables
>
> Tony Lindgren (2):
>      omap: Fix incorrect 730 vs 850 detection
>      Merge branch 'pm-fixes-32' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-fixes-for-linus
>
> Vikram Pandita (1):
>      OMAP3: PM: USBHOST: clear wakeup events on both hosts
>
> ye janboe (1):
>      omap: SRAM: flush the right address after memcpy in omap_sram_push

The beagleboard is still not booting for me with this branch, I need
to add these two patches:

* http://patchwork.kernel.org/patch/50721/

This one is needed because the defconfig has:
CONFIG_TWL4030_USB=y

* http://patchwork.kernel.org/patch/50970/

This is needed because most people boot from an MMC.

You can add my 'tested-by' line if you want.

Cheers.

-- 
Felipe Contreras
