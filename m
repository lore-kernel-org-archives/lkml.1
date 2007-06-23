Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbXFWWNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbXFWWNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 18:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXFWWM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 18:12:56 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46903 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbXFWWMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 18:12:55 -0400
Date: Sun, 24 Jun 2007 00:13:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: jimmy bahuleyan <knight.camelot@gmail.com>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org
Subject: Re: make xconfig failure on 2.6.21.5
Message-ID: <20070623221359.GA9364@uranus.ravnborg.org>
References: <467D6A21.8020507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467D6A21.8020507@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 12:14:49AM +0530, jimmy bahuleyan wrote:
> 
> Hi,
> 
> I have a Kubuntu 7.04 distro with Qt4 development packages installed.
> Trying to do a 'make xconfig' fails with:
> 
>   HOSTCC  scripts/basic/fixdep
>   HOSTCC  scripts/basic/docproc
>   CHECK   qt
> *
> * Unable to find the QT installation. Please make sure that
> * the QT development package is correctly installed and
> * either install pkg-config or set the QTDIR environment
> * variable to the correct location.
> *
>   HOSTCC  scripts/kconfig/conf.o
> sed < scripts/kconfig/lkc_proto.h > scripts/kconfig/lkc_defs.h
> 's/P(\([^,]*\),.*/#define \1 (\*\1_p)/'
>   HOSTCC  scripts/kconfig/kconfig_load.o
>   HOSTCC  scripts/kconfig/kxgettext.o
>   SHIPPED scripts/kconfig/zconf.tab.c
>   SHIPPED scripts/kconfig/lex.zconf.c
>   SHIPPED scripts/kconfig/zconf.hash.c
>   HOSTCC  scripts/kconfig/zconf.tab.o
> make[1]: *** No rule to make target `scripts/kconfig/.tmp_qtcheck',
> needed by `scripts/kconfig/qconf.o'.  Stop.
> make: *** [xconfig] Error 2
> 
> 
> Is this a problem with my setup or that kbuild/kconfig can't handle Qt4?

xconfig does not yet support qt4 (IIRC).
So you will need qt3 packages to build xconfig.
Patches to introduce qt4 config without breaking qt3 config
are appreciated...

	Sam
