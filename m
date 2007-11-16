Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbXKPFjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbXKPFjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 00:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbXKPFjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 00:39:46 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53952 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbXKPFjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 00:39:46 -0500
Date: Fri, 16 Nov 2007 06:41:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
Message-ID: <20071116054126.GA28606@uranus.ravnborg.org>
References: <11947274091127-git-send-email-sam@ravnborg.org> <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org> <Pine.LNX.4.64.0711151616330.1817@scrub.home> <20071115192555.GD23914@uranus.ravnborg.org> <Pine.LNX.4.64.0711152036430.1817@scrub.home> <20071115204520.GA24851@uranus.ravnborg.org> <Pine.LNX.4.64.0711152158310.1817@scrub.home> <20071115220640.GA25265@uranus.ravnborg.org> <Pine.LNX.4.64.0711160205340.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711160205340.1817@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman.
> > If user did NOT specify ARCH we should use the kernel configuration - which
> > your solution fail to do.
> 
> To make this easy I attached the patch which reverts the problematic 
> changes and then you only need this simple change to force the 64BIT value 
> for ARCH={i386,x86_64}, otherwise it's set by the user:

Just eyeballing your patch I made following observations:
1) make all*config, randconfig, defconfig is broken on 64-bit boxes
2) A pure code refactoring patch is reverted for no obvious reason
3) Behavioral changes are not documented:
   - 32-bit/64-bit can only be selected in config is you specify ARCH=x86
   - ARCH= takes precedence over kernel config for a configured kernel
4) The changelogs miss title on reverted patches

All points are trivial to fix so I do not say your approach is
bad - just that the supplied patch is not good enough.

I will fix it up tonight and test it.

	Sam
