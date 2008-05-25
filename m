Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbYEYAaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbYEYAaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 20:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYEYAaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 20:30:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:16629 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbYEYAaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 20:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QOmH6ZRnWA1NO6fCTPX1LEOmoPGOM5WkuxTnWGw2yCvBSJhtmVAONzv8clbZr/KglKHRM5zvU1ThZmxD9kwi7YqvTcINUjTG2zcBisjta6CbMcdOWHpEwsIPY9c46Yz9nZuCgLWI9n/aqfawlTTp416UJnS0wakwW2hClNSwcgo=
Message-ID: <b6a2187b0805241730x4a9d31b6k8f439088f63bcc9b@mail.gmail.com>
Date: Sun, 25 May 2008 08:30:09 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.26-rc3-git7: Reported regressions from 2.6.25
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 4:28 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10759
> Subject         : recent 2.6.26 kernel hangs at suspend
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2008-05-19 15:07 (6 days old)
> References      : http://marc.info/?l=linux-kernel&amp;m=121121007814338&amp;w=2
> Handled-By      : Len Brown <lenb@kernel.org>
>                  Pavel Machek <pavel@suse.cz>


This has been fixed by this commit.

commit 860da5e578c25d1ab4528c0d1ad13f9969e3490f
Merge: 1bf9947... e948e99...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon May 19 13:30:40 2008 -0700

    Merge branch 'drm-patches' of git://git.kernel.org/pub/scm/linux/kernel/git/
airlied/drm-2.6

    * 'drm-patches' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm
-2.6:
      drm/i915: save and restore dsparb and d_state registers.
      drm/i915: fix off by one in VGA save/restore of AR & CR regs.
      drm: disable tasklets not IRQs when taking the drm lock spinlock
      Revert "drm/vbl rework: rework how the drm deals with vblank."



Thanks,
Jeff.
