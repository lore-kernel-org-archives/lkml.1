Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbXKGHFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbXKGHFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 02:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbXKGHFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 02:05:08 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53924 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbXKGHFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 02:05:07 -0500
Date: Wed, 7 Nov 2007 08:06:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unification of cfufreq/Kconfig
Message-ID: <20071107070644.GA13937@uranus.ravnborg.org>
References: <11943900793940-git-send-email-sam@ravnborg.org> <20071107060220.GX26163@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107060220.GX26163@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 07:02:20AM +0100, Adrian Bunk wrote:
> On Wed, Nov 07, 2007 at 12:01:12AM +0100, Sam Ravnborg wrote:
> >...
> >  config X86_SPEEDSTEP_CENTRINO
> > -	tristate "Intel Enhanced SpeedStep"
> > +	tristate "Intel Enhanced SpeedStep (deprecated)"
> >  	select CPU_FREQ_TABLE
> > -	select X86_SPEEDSTEP_CENTRINO_TABLE
> > +	select X86_SPEEDSTEP_CENTRINO_TABLE if X86_32
> > +	depends on X86_64 && ACPI_PROCESSOR
> >...
> 
> No.
> 
> 	depends on ACPI_PROCESSOR if X86_64

Gives syntax error.

	Sam
