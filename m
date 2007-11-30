Return-Path: <linux-kernel-owner+w=401wt.eu-S935410AbXK3SJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935410AbXK3SJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934231AbXK3SJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:09:31 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:41032 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934832AbXK3SJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:09:30 -0500
Date: Fri, 30 Nov 2007 13:09:21 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jarek Poplawski <jarkao2@o2.pl>
Subject: Re: [PATCH] Documentation/Changes -> Documentation/Requirements
In-Reply-To: <200711301747.lAUHlDdM006716@tazenda.hos.anvin.org>
Message-ID: <alpine.LFD.0.9999.0711301256520.7197@localhost.localdomain>
References: <20071130071647.GA2017@ff.dom.local> <200711301747.lAUHlDdM006716@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, H. Peter Anvin wrote:

> diff --git a/Documentation/Requirements b/Documentation/Requirements
> new file mode 100644
> index 0000000..bd7bc2c
> --- /dev/null
> +++ b/Documentation/Requirements
> @@ -0,0 +1,394 @@

> +Minimal Runtime Requirements
> +============================
> +
> +Upgrade to at *least* these software revisions before thinking you've
> +encountered a bug!  If you're unsure what version you're currently
> +running, the suggested command should tell you.
> +
> +Again, keep in mind that this list assumes you are already
> +functionally running a Linux 2.4 kernel.  Also, not all tools are
> +necessary on all systems; obviously, if you don't have any ISDN
> +hardware, for example, you probably needn't concern yourself with
> +isdn4k-utils.
> +
> +o  util-linux             2.10o                   # fdformat --version
> +o  module-init-tools      0.9.10                  # depmod -V

given that, on my F8 system, i'm up to module-init-tools 3.4, is
something as old as 0.9.10 still adequate?

> +o  e2fsprogs              1.29                    # tune2fs
> +o  jfsutils               1.1.3                   # fsck.jfs -V
> +o  reiserfsprogs          3.6.3                   # reiserfsck -V 2>&1|grep reiserfsprogs
> +o  xfsprogs               2.6.0                   # xfs_db -V
> +o  pcmciautils            004                     # pccardctl -V

same here -- f8 has pcmciautils version 014, so 004 is getting
ancient.

> +o  quota-tools            3.09                    # quota -V

quota-tools is actually just the "quota" package on fedora, but that's
probably not worth obsessing over.

> +o  PPP                    2.4.0                   # pppd --version
> +o  isdn4k-utils           3.1pre1                 # isdnctrl 2>&1|grep version
> +o  nfs-utils              1.0.5                   # showmount --version
> +o  procps                 3.2.0                   # ps --version
> +o  oprofile               0.9                     # oprofiled --version
> +o  udev                   081                     # udevinfo -V
> +o  grub                   0.93                    # grub --version
> +
> +
> +Kernel Compilation Requirements
> +===============================
> +
> +On all systems, minimal requirements (see below for additional notes):
> +
> +o  Gnu C                  3.2                     # gcc --version
> +o  Gnu make               3.79.1                  # make --version
> +o  binutils               2.12                    # ld -v
> +o  Gnu bc                 1.06                    # bc -v

you need bc?  for what?  i just did a defconfig build for x86 with no
need for bc.

> +o  Perl                   5.6.0(?)                # perl -v

if you mention perl, you should also mention sed and awk, no?  and
perhaps suggest running scripts/ver_linux.

more later.

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
