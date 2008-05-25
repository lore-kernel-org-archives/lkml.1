Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYEYSb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYEYSb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757523AbYEYSbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:31:03 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54312 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757465AbYEYSbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:31:01 -0400
Date: Sun, 25 May 2008 21:28:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.26-rc3-git7: Reported regressions from 2.6.25
Message-ID: <20080525182824.GI1791@cs181133002.pp.htv.fi>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <b6a2187b0805241730x4a9d31b6k8f439088f63bcc9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b6a2187b0805241730x4a9d31b6k8f439088f63bcc9b@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 08:30:09AM +0800, Jeff Chua wrote:
> On Sun, May 25, 2008 at 4:28 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10759
> > Subject         : recent 2.6.26 kernel hangs at suspend
> > Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> > Date            : 2008-05-19 15:07 (6 days old)
> > References      : http://marc.info/?l=linux-kernel&amp;m=121121007814338&amp;w=2
> > Handled-By      : Len Brown <lenb@kernel.org>
> >                  Pavel Machek <pavel@suse.cz>
> 
> 
> This has been fixed by this commit.
> 
> commit 860da5e578c25d1ab4528c0d1ad13f9969e3490f
> Merge: 1bf9947... e948e99...
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon May 19 13:30:40 2008 -0700
> 
>     Merge branch 'drm-patches' of git://git.kernel.org/pub/scm/linux/kernel/git/
> airlied/drm-2.6
> 
>     * 'drm-patches' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm
> -2.6:
>       drm/i915: save and restore dsparb and d_state registers.
>       drm/i915: fix off by one in VGA save/restore of AR & CR regs.
>       drm: disable tasklets not IRQs when taking the drm lock spinlock
>       Revert "drm/vbl rework: rework how the drm deals with vblank."

Thanks, closed.

> Thanks,
> Jeff.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

