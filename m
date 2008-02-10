Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYBJVaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYBJVaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYBJVaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:30:05 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:56756 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbYBJVaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:30:04 -0500
Date: Sun, 10 Feb 2008 22:30:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [0/6] kgdb light
Message-ID: <20080210213010.GB14739@uranus.ravnborg.org>
References: <20080210071304.GA3788@elte.hu> <20080210104709.GB10790@uranus.ravnborg.org> <47AEFB40.5070208@web.de> <20080210193153.GC13733@uranus.ravnborg.org> <20080210211641.GC29507@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210211641.GC29507@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> btw., we should convert all those current:
> 
>  config ARCH_POPULATES_NODE_MAP
>          def_bool y
> 
>  config AUDIT_ARCH
>          bool
>          default X86_64
> 
>  config ARCH_SUPPORTS_AOUT
>          def_bool y
> 
> instances to select lines after config X86 / config X86_64.
> 
> KGDB just followed the current Kconfig style status quo.

Indeed. I just do not have time to do so. A day-time job that
is not about kernel-hacking, three kids and a wife etc. consumes
some decent amount of time and leaves only a few hours for linux.
And I am a strange person that actually needs to sleep several
hours each night (as my baby daughter permits me to).


I promote the "select HAVE_*" style on all new stuff and expect that
a herd of janitors one day pick it up and convert most of the old-style
stuff.
And if you look around then you will see that for this merge window
almost all new stuff used "select HAVE_" so we on the right track.

	Sam
