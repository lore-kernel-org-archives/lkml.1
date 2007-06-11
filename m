Return-Path: <linux-kernel-owner+w=401wt.eu-S1762170AbXFKHaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170AbXFKHaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 03:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbXFKH3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 03:29:53 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:48266 "EHLO
	toronto.xi-lite.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751021AbXFKH3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 03:29:52 -0400
Message-ID: <466CF903.10003@parrot.com>
Date: Mon, 11 Jun 2007 09:25:55 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Tom <fivemiletom@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: RE : Building kernel 2.6.21.3 for arm on cygwin
References: <4660971E.5020609@gmail.com> <12D4B80525C5B744A216276E209921D9CE8016@MIAMI.xi-lite.lan> <46645DC9.8080003@gmail.com> <20070607204707.GB16634@uranus.ravnborg.org> <46697C5E.9060607@parrot.com> <20070608221032.GA26637@uranus.ravnborg.org>
In-Reply-To: <20070608221032.GA26637@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2007 07:28:24.0005 (UTC) FILETIME=[183B1F50:01C7ABFA]
X-AV-Checked: No Virus Found
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Sam Ravnborg wrote:
> Hi Matthieu.
> 
> Can you please try to tell what your patch actually does.
> 
> As for the part added in the MAkefile you pass -lintl for Cygwin -
> but I fail to see _why_ -lintl is needed.
If I don't do it, I got [1] or [2].

Matthieu

[1]
scripts/kconfig/conf.o:conf.c:(.text+0x91): undefined reference to 
`_libintl_gettext'
scripts/kconfig/conf.o:conf.c:(.text+0xa5): undefined reference to 
`_libintl_gettext'
scripts/kconfig/conf.o:conf.c:(.text+0xb9): undefined reference to 
`_libintl_gettext'
scripts/kconfig/conf.o:conf.c:(.text+0x7b8): undefined reference to 
`_libintl_gettext'
scripts/kconfig/conf.o:conf.c:(.text+0xf19): undefined reference to 
`_libintl_gettext'
scripts/kconfig/conf.o:conf.c:(.text+0x1026): more undefined references 
to `_libintl_gettext' follow
collect2: ld returned 1 exit status

[2]
scripts/kconfig/mconf.o:mconf.c:(.text+0x923): undefined reference to 
`_libintl_gettext'
scripts/kconfig/mconf.o:mconf.c:(.text+0x9c9): undefined reference to 
`_libintl_gettext'
scripts/kconfig/mconf.o:mconf.c:(.text+0xa66): undefined reference to 
`_libintl_gettext'
scripts/kconfig/mconf.o:mconf.c:(.text+0xa91): undefined reference to 
`_libintl_gettext'
scripts/kconfig/mconf.o:mconf.c:(.text+0xab1): undefined reference to 
`_libintl_gettext'
scripts/kconfig/mconf.o:mconf.c:(.text+0xadd): more undefined references 
to `_libintl_gettext' follow
scripts/kconfig/mconf.o:mconf.c:(.text+0x11af): undefined reference to 
`_libintl_bindtextdomain'
scripts/kconfig/mconf.o:mconf.c:(.text+0x11bb): undefined reference to 
`_libintl_textdomain'
scripts/kconfig/mconf.o:mconf.c:(.text+0x1207): undefined reference to 
`_libintl_gettext'
scripts/kconfig/mconf.o:mconf.c:(.text+0x1414): undefined reference to 
`_libintl_gettext'
scripts/kconfig/mconf.o:mconf.c:(.text+0x1467): undefined reference to 
`_libintl_gettext'
scripts/kconfig/mconf.o:mconf.c:(.text+0x1482): undefined reference to 
`_libintl_gettext'
scripts/kconfig/mconf.o:mconf.c:(.text+0x14af): undefined reference to 
`_libintl_gettext'
scripts/kconfig/zconf.tab.o:zconf.tab.c:(.text+0x54e6): more undefined 
references to `_libintl_gettext' follow
Info: resolving _stdscr by linking to __imp__stdscr (auto-import)
Info: resolving _COLS by linking to __imp__COLS (auto-import)
Info: resolving _LINES by linking to __imp__LINES (auto-import)
collect2: ld returned 1 exit status
