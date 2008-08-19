Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbYHSVWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbYHSVWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYHSVVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:21:53 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:10357 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbYHSVVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:21:52 -0400
Date: Tue, 19 Aug 2008 21:25:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rc2 when cross-building the kernel
Message-ID: <20080819192508.GA6774@uranus.ravnborg.org>
References: <48A63D98.3070900@lwfinger.net> <20080818193253.GA30856@uranus.ravnborg.org> <48A9FA05.9000601@lwfinger.net> <20080819044854.GA2276@uranus.ravnborg.org> <1219132135.3184.461.camel@pmac.infradead.org> <48AAFB4C.1030300@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AAFB4C.1030300@lwfinger.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 11:56:44AM -0500, Larry Finger wrote:
> David Woodhouse wrote:
> >On Tue, 2008-08-19 at 06:48 +0200, Sam Ravnborg wrote:
> >>And Larry log say it is so.
> >>
> >>David - did you have a patch to fix this already?
> >
> >The fix was to 'build' the firmware blobs at the same time as 'make
> >modules', so that they're already built and don't need to be built at
> >modules_install time. That went in a while ago though.
> >
> >Why is ihex2fw being rebuilt?
> >
> 
> sudo make V=2 modules_install says:
> 
>   HOSTCC  firmware/ihex2fw - due to: /usr/include/gnu/stubs-64.h 
> /usr/lib64/gcc/x86_64-suse-linux/4.3/include/stddef.h 
> /usr/lib64/gcc/x86_64-suse-linux/4.3/include-fixed/limits.h 
> /usr/lib64/gcc/x86_64-suse-linux/4.3/include-fixed/syslimits.h 
> /usr/lib64/gcc/x86_64-suse-linux/4.3/include/stdarg.h
> /bin/sh: scripts/basic/fixdep: cannot execute binary file
> make[1]: *** [firmware/ihex2fw] Error 126
> make: *** [_modinst_post] Error 2

Do you have some logging info before we start to build ihex2fw?

	Sam
