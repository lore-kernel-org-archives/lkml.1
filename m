Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbXKDSGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbXKDSGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXKDSFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:05:55 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:48996 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbXKDSFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:05:54 -0500
Date: Sun, 4 Nov 2007 19:07:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] x86: start unification of arch/x86/Kconfig.*
Message-ID: <20071104180731.GA18771@uranus.ravnborg.org>
References: <11941338801315-git-send-email-sam@ravnborg.org> <11941338804007-git-send-email-sam@ravnborg.org> <20071104014401.GI12045@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071104014401.GI12045@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >  config DMAR_FLOPPY_WA
> >  	bool
> >  	depends on DMAR
> >...
> 
> In patch 8 the remaining PCI_* options and DMAR_FLOPPY_WA end in a 
> completely different place in the Kconfig file than the options moved 
> here.
> 
> Please keep options that belong together grouped together no matter 
> whether all of them are user visible.

I was obviously considering this and saw this as next unification step.
But I will try to integrate it in this serie and will probarly extend
the serie to include consolidation of both the arch-config-settings
and the various kconfig-helper variables like the DMAR_FLOPPY_WA
above.
It will take a day or two since I have a few non-linux things to do first.

	Sam
