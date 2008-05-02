Return-Path: <linux-kernel-owner+w=401wt.eu-S933130AbYEBK4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbYEBK4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760095AbYEBKz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:55:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35334 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbYEBKz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:55:56 -0400
Date: Fri, 2 May 2008 12:56:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>,
       Roland McGrath <roland@redhat.com>,
       Andres Salomon <dilinger@queued.net>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Message-ID: <20080502105630.GA20955@uranus.ravnborg.org>
References: <20080429183531.GB19652@uranus.ravnborg.org> <alpine.LNX.1.10.0804301643140.5623@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0804301643140.5623@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >(The other frontends are left out on purpose).
> >The challenge here is to come up with a syntax that
> >allows us to select between the three behaviours,
> >while keeping backward compatibility.
> >
> >The best suggestion I have so far is to say that:
> >a) if defconfig is specified then we use method 1)
> >b) if oldconfig is specified then we use method 2)
> >c) if newconfig is specified then we use method 3)
> 
> [Where is 1) defined?]

1) automated - select defaults for all new symbols
   => It is used for "make defconfig, make *_defconfig" today

> Ok and these are doing .. what?

> ># Enviroment variables affecting kconfig
> >KCONFIG_ALLCONFIG

Specify input file in .config format to adjust a all*config run

> >KCONFIG_NOSILENTUPDATE
If set then error out if .config is modified

> >KCONFIG_CONFIG
Provide alternative name for .config

> >KCONFIG_OVERWRITECONFIG
If you set KCONFIG_OVERWRITECONFIG in environment, Kconfig will not break
 symlinks when .config is a symlink to somewhere else

> >KCONFIG_NOTIMESTAMP
Do not put timestamp in .config

> >KCONFIG_AUTOCONFIG
Provide alternative name for: include/config/auto.conf

> >KCONFIG_AUTOHEADER
Provide alternative name for include/linux/autoconf.h 




> Used for..?
All used to hardcode specific values in all*config builds.

> >#input files (aparts from the mandatory ones)
> >all.config
> >allno.config
> >allmod.config
> >allyes.config
> >allrandom.config

	Sam
