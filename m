Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXKDIeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXKDIeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 03:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbXKDId4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 03:33:56 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:47925 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbXKDIdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 03:33:55 -0500
Date: Sun, 4 Nov 2007 09:35:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] x86: unification of cfufreq/Kconfig
Message-ID: <20071104083533.GA16683@uranus.ravnborg.org>
References: <11941338801315-git-send-email-sam@ravnborg.org> <20071104012858.GH12045@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071104012858.GH12045@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 02:28:59AM +0100, Adrian Bunk wrote:
> On Sun, Nov 04, 2007 at 12:51:11AM +0100, Sam Ravnborg wrote:
> >...
> >  config X86_SPEEDSTEP_CENTRINO
> > -	tristate "Intel Enhanced SpeedStep"
> > +	tristate "Intel Enhanced SpeedStep (deprecated)"
> >  	select CPU_FREQ_TABLE
> > -	select X86_SPEEDSTEP_CENTRINO_TABLE
> > +	select X86_SPEEDSTEP_CENTRINO_TABLE if X86_32
> >  	help
> >...
> 
> 	depends on ACPI_PROCESSOR if X86_64

Good catch - thanks.
I will update the patch set tonight (morning here).

	Sam
