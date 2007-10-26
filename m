Return-Path: <linux-kernel-owner+w=401wt.eu-S1763055AbXJZHA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763055AbXJZHA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759793AbXJZG5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:57:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45283 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbXJZG5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:57:06 -0400
Date: Fri, 26 Oct 2007 08:58:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 5/6] x86: move i386 and x86_64 Kconfig files to x86 directory
Message-ID: <20071026065840.GA19490@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org> <20071025200546.GF14501@uranus.ravnborg.org> <86802c440710251853w1b33ea66j13181664cb5a30a0@mail.gmail.com> <20071025194653.46d39a13.rdunlap@xenotime.net> <86802c440710252251v1ad07c12x22254c1b4ed3ceee@mail.gmail.com> <20071026061425.GA19022@uranus.ravnborg.org> <86802c440710252339kcf5d46dh4602fff9ac8d3a66@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440710252339kcf5d46dh4602fff9ac8d3a66@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> BTW:
> why not using Kconfig.x86_32 instead of Kconfig.i386?

See scripts/kconfig/Makefile:
Here we use (in the x86 case):
Kconfig := arch/$(SRCARCH)/Kconfig.$(ARCH)

So the "i386" comes from ARCH equals to i386.

The advantage is that the patch to kconfig
is generic so other arch's can use SRCARCH if they like
without having a hardcoded list in the kconfig Makefile.

	Sam
