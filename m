Return-Path: <linux-kernel-owner+w=401wt.eu-S1762264AbXKQHzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264AbXKQHzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 02:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXKQHzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 02:55:35 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37868 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbXKQHze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 02:55:34 -0500
Date: Sat, 17 Nov 2007 08:57:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andreas Herrmann <aherrman@arcor.de>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Kconfig: ARCH=x86 causes wrong utsname.machine
Message-ID: <20071117075715.GB4723@uranus.ravnborg.org>
References: <20071116111446.GA16968@devil> <20071116123747.GA12086@devil> <473DB52F.2040703@zytor.com> <20071116221535.GA1810@uranus.ravnborg.org> <473E209A.7080806@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473E209A.7080806@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >Any good suggestions here???
> >UTS_MACHINE is set in top-level Makefile and if we specify
> >make ARCH=x86
> >we do not know if i386 or x86_&4 is correct until the configuration
> >has been read.
> >
> >Should we report a "make ARCH=x86" as uname -m == x86??
> >
> 
> That would break 5 years of a stable ABI.  I don't think that is even 
> remotely feasible.

I will try to cook up a patch that sets CONFIG_UTS_MACHINE
and then we will use that value unless it is undefined in which
case we fall back to UTS_MACHINE (as today).

	Sam
