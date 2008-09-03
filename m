Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbYICU3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbYICU3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbYICU3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:29:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:39652 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYICU3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=lbV694PETNKN2A7sg3eD0+Aj8Qr97C0hB2J/kpfvcacp/z7nVKbxdNgAxvNUglcK+E
         dfBd3rkdwEnK0xlNu2OFKJLeKEhj8mgP0nx27+0WYSjPmr4E2Jnbv6Ck9Is9KQkwbbl4
         YnR0jlHmvwxQTuARAGBiF7JpiGLUWhW4bIY6Y=
Date: Wed, 3 Sep 2008 22:29:27 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Nir Tzachar <tzachar@grad120a.cs.bgu.ac.il>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Nir Tzachar <nir@tzachar.com>
Subject: Re: [PATCH] ncurses based config
Message-ID: <20080903222927.7d191458@Varda>
In-Reply-To: <Pine.LNX.4.64.0809031259110.20541@shark.he.net>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com>
	<200809032138.14651.bzolnier@gmail.com>
	<Pine.LNX.4.64.0809031259110.20541@shark.he.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 3 Sep 2008 13:02:42 -0700 (PDT)
"Randy.Dunlap" <rdunlap@xenotime.net> escribió:

> On Wed, 3 Sep 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> > 
> > Hi,
> > 
> > On Wednesday 03 September 2008, Nir Tzachar wrote:
> > > This patch was inspired by the kernel projects page, where an ncurses
> > > replacement for menuconfig was mentioned (by Sam Ravnborg).
> > > 
> > > Building on menuconfig, this patch implements a more modern look interface using
> > > ncurses and ncurses' satellite libraries (menu, panel, form). The implementation
> > > does not depend on lxdialog, which is currently distributed with the kernel.
> > > 
> > > The only change outside of nconf.c is due to a name clash: both ncurses and
> > > lkc.h define a fucntion named menu_init(). I changed the internal version's
> > > name. 
> > > 
> > > Please consider the patch for merging. Comments are appreciated.
> > 
> > Could you please tell what kernel version is it against?
> 
> It applies cleanly to 2.6.27-rc5-git4 FWIW.
> 
> > I'm getting the following error on make nconfig (and also on make menuconfig
> > which works fine without this patch) with the current Linus' tree:
> > 
> >   HOSTCC  scripts/kconfig/conf.o
> >   HOSTCC  scripts/kconfig/kxgettext.o
> >   HOSTCC  scripts/kconfig/nconf.o
> >   HOSTCC  scripts/kconfig/zconf.tab.o
> > scripts/kconfig/zconf.tab.c: In function ÿÿconf_parseÿÿ:
> > scripts/kconfig/zconf.tab.c:2258: warning: implicit declaration of function ÿÿmenu_initÿÿ
> >   HOSTLD  scripts/kconfig/nconf
> > scripts/kconfig/nconf arch/x86/Kconfig
> > make[1]: *** [nconfig] Segmentation fault
> > make: *** [nconfig] Error 2
> 
> Need to change all /menu_init/ in zconf.tab.c* to /_menu_init/.

 Tried it

> 
> Need to strip trailing whitespace on new source code lines.
> 
> I'm seeing cyan (?) foreground on black background.  Is that the colors
> that were planned?
  
 much nicer colors here (ubuntu) 
 http://img177.imageshack.us/my.php?image=pantallazonm7.png

> 
> Instructions are dark blue on black -- cannot read them.
> 

 
