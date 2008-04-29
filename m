Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbYD2KvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbYD2KvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYD2Ku5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:50:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39797 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbYD2Ku4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:50:56 -0400
Date: Tue, 29 Apr 2008 12:50:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       dsd@gentoo.org
Subject: Re: [PATCH] x86: use defconfigs from x86/configs/*
Message-ID: <20080429105037.GQ23198@elte.hu>
References: <20080429104815.GA16753@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429104815.GA16753@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> Daniel Drake <dsd@gentoo.org> reported:
> 
> In 2.6.23, if you unpacked a kernel source tarball and then
> ran "make menuconfig" you'd be presented with this message:
>     # using defaults found in arch/i386/defconfig
> 
> and the default options would be set.
> 
> The same thing in 2.6.24 does not give you any "using defaults" 
> message, and the default config options within menuconfig are rather 
> blank (e.g. no PCI support). You can work around this by explicitly 
> running "make defconfig" before menuconfig, but it would be nice to 
> have the behaviour the way it was for 2.6.23 (and the way it still is 
> for other archs).
> 
> Fixed by adding a x86 specific defconfig list to Kconfig.

thanks Sam, applied.

	Ingo
