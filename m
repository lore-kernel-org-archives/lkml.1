Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZIZVnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZIZVnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 17:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZIZVnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 17:43:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58001 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZIZVna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 17:43:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Date: Sat, 26 Sep 2009 23:44:21 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Joseph Cihula <joseph.cihula@intel.com>,
       Shane Wang <shane.wang@intel.com>
References: <200909142051.n8EKpiOM017912@terminus.zytor.com> <20090926095631.GH1331@ucw.cz>
In-Reply-To: <20090926095631.GH1331@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909262344.21257.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 September 2009, Pavel Machek wrote:
> Hi!
> 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-txt-for-linus
> > 
> > Arnaldo Carvalho de Melo (1):
> >       x86, intel_txt: Fix typos in Kconfig help
> > 
> > H. Peter Anvin (3):
> >       x86, intel_txt: Factor out the code for S3 setup
> >       x86, intel_txt: Handle ACPI_SLEEP without X86_TRAMPOLINE
> 
> This went in despite my NAK/request for more info. It seems you are
> simply ignoring feedback you don't like :-(

The "x86, intel_txt: Handle ACPI_SLEEP without X86_TRAMPOLINE" commit looks
entirely correct to me.

I have no comments on "x86, intel_txt: Factor out the code for S3 setup" as
well, maybe except that the BUG() in tboot_setup_sleep() in the
!CONFIG_ACPI_SLEEP case is a bit unfortunate.

Thanks,
Rafael
