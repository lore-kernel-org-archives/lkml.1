Return-Path: <linux-kernel-owner+w=401wt.eu-S1161260AbXDYOfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161260AbXDYOfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161218AbXDYOfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:35:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:16777 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161260AbXDYOfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Bs7xKKmt0Y4AozsL74KscFYqtYqQxmRK0O+i02oY6bU/8Uq9/M2TtBqdmbrYz+ecQUpq8b8Vi1hm1V7qw01och5E6phvl5spSd/p3OIWuVgyMNPHXqiRBh3lWcI4LDbJrjNwrkAYA5P1KYCcpuF1hAXdj/EIzQGluDO2XrKv458=
Message-ID: <a8f16e2b0704250735n6895a19mf14761a82c5933b5@mail.gmail.com>
Date: Wed, 25 Apr 2007 18:35:42 +0400
From: "Dan Kruchinin" <dubalom@gmail.com>
To: "Sunil Naidu" <akula2.shark@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: menuconfig issue (checklist) in 2.6.20.7 & 2.6.21-rc7 ?
In-Reply-To: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/07, Sunil Naidu <akula2.shark@gmail.com> wrote:
> Hello,

Hi

> I was trying to compile those kernels with make menuconfig. I am
> getting the error in scripts/kconfig/lxdialog/checklist.o. Here is the
> output:
>
> [sukhoi@Akula2 linux-2.6.20.7]$ sudo make menuconfig
>   HOSTCC  scripts/kconfig/lxdialog/checklist.o
> In file included from scripts/kconfig/lxdialog/checklist.c:24:
> scripts/kconfig/lxdialog/dialog.h:32:20: error: curses.h: No such file
> or directory
> In file included from scripts/kconfig/lxdialog/checklist.c:24:
> scripts/kconfig/lxdialog/dialog.h:97: error: expected
> specifier-qualifier-list before
>  'chtype'
> scripts/kconfig/lxdialog/dialog.h:187: error: expected ')' before '*' token
> scripts/kconfig/lxdialog/dialog.h:193: error: expected ')' before '*' token
> scripts/kconfig/lxdialog/dialog.h:195: error: expected ')' before '*' token
> scripts/kconfig/lxdialog/dialog.h:196: error: expected ')' before '*' token
> scripts/kconfig/lxdialog/dialog.h:197: error: expected ')' before '*' token
> scripts/kconfig/lxdialog/dialog.h:198: error: expected ')' before '*' token
> scripts/kconfig/lxdialog/dialog.h:200: error: expected ')' before '*' token
> scripts/kconfig/lxdialog/checklist.c:31: error: expected ')' before '*' token
> scripts/kconfig/lxdialog/checklist.c:59: error: expected ')' before '*' token
> scripts/kconfig/lxdialog/checklist.c:95: error: expected ')' before '*' token
> scripts/kconfig/lxdialog/checklist.c: In function 'dialog_checklist':
> scripts/kconfig/lxdialog/checklist.c:116: error: 'WINDOW' undeclared
> (first use in th
> is function)
> scripts/kconfig/lxdialog/checklist.c:116: error: (Each undeclared
> identifier is repor
> ted only once
> scripts/kconfig/lxdialog/checklist.c:116: error: for each function it
> appears in.)
> scripts/kconfig/lxdialog/checklist.c:116: error: 'dialog' undeclared
> (first use in th
> is function)
> scripts/kconfig/lxdialog/checklist.c:116: error: 'list' undeclared
> (first use in this
>  function)
> scripts/kconfig/lxdialog/checklist.c:116: warning: left-hand operand
> of comma express
> ion has no effect
> scripts/kconfig/lxdialog/checklist.c:129: warning: implicit
> declaration of function '
> getmaxy'
> scripts/kconfig/lxdialog/checklist.c:129: error: 'stdscr' undeclared
> (first use in th
> is function)
> scripts/kconfig/lxdialog/checklist.c:130: error: 'KEY_MAX' undeclared
> (first use in t
> his function)
> scripts/kconfig/lxdialog/checklist.c:131: warning: implicit
> declaration of function '
> getmaxx'
> scripts/kconfig/lxdialog/checklist.c:137: error: 'COLS' undeclared
> (first use in this
>  function)
> scripts/kconfig/lxdialog/checklist.c:138: error: 'LINES' undeclared
> (first use in thi
> s function)
> scripts/kconfig/lxdialog/checklist.c:140: warning: implicit
> declaration of function '
> draw_shadow'
> scripts/kconfig/lxdialog/checklist.c:142: warning: implicit
> declaration of function '
> newwin'
> scripts/kconfig/lxdialog/checklist.c:143: warning: implicit
> declaration of function '
> keypad'
> scripts/kconfig/lxdialog/checklist.c:143: error: 'TRUE' undeclared
> (first use in this
>  function)
> scripts/kconfig/lxdialog/checklist.c:145: warning: implicit
> declaration of function '
> draw_box'
> scripts/kconfig/lxdialog/checklist.c:146: error: 'struct dialog_color'
> has no member
> named 'atr'
> scripts/kconfig/lxdialog/checklist.c:146: error: 'struct dialog_color'
> has no member
> named 'atr'
> scripts/kconfig/lxdialog/checklist.c:147: warning: implicit
> declaration of function '
> wattrset'
> scripts/kconfig/lxdialog/checklist.c:147: error: 'struct dialog_color'
> has no member
> named 'atr'
> scripts/kconfig/lxdialog/checklist.c:148: warning: implicit
> declaration of function '
> mvwaddch'
> scripts/kconfig/lxdialog/checklist.c:150: warning: implicit
> declaration of function '
> waddch'
> scripts/kconfig/lxdialog/checklist.c:151: error: 'struct dialog_color'
> has no member
> named 'atr'
> scripts/kconfig/lxdialog/checklist.c:154: warning: implicit
> declaration of function '
> print_title'
> scripts/kconfig/lxdialog/checklist.c:156: error: 'struct dialog_color'
> has no member
> named 'atr'
> scripts/kconfig/lxdialog/checklist.c:157: warning: implicit
> declaration of function '
> print_autowrap'
> scripts/kconfig/lxdialog/checklist.c:164: warning: implicit
> declaration of function '
> subwin'
> scripts/kconfig/lxdialog/checklist.c:171: error: 'struct dialog_color'
> has no member
> named 'atr'
> scripts/kconfig/lxdialog/checklist.c:171: error: 'struct dialog_color'
> has no member
> named 'atr'
> scripts/kconfig/lxdialog/checklist.c:189: warning: implicit
> declaration of function '
> print_item'
> scripts/kconfig/lxdialog/checklist.c:192: warning: implicit
> declaration of function '
> print_arrows'
> scripts/kconfig/lxdialog/checklist.c:195: warning: implicit
> declaration of function '
> print_buttons'
> scripts/kconfig/lxdialog/checklist.c:197: warning: implicit
> declaration of function '
> wnoutrefresh'
> scripts/kconfig/lxdialog/checklist.c:199: warning: implicit
> declaration of function '
> doupdate'
> scripts/kconfig/lxdialog/checklist.c:202: warning: implicit
> declaration of function '
> wgetch'
> scripts/kconfig/lxdialog/checklist.c:210: error: 'KEY_UP' undeclared
> (first use in th                         is function)
> scripts/kconfig/lxdialog/checklist.c:210: error: 'KEY_DOWN' undeclared
> (first use in                          this function)
> scripts/kconfig/lxdialog/checklist.c:220: error: 'FALSE' undeclared
> (first use in thi                         s function)
> scripts/kconfig/lxdialog/checklist.c:221: warning: implicit
> declaration of function '                         scrollok'
> scripts/kconfig/lxdialog/checklist.c:222: warning: implicit
> declaration of function '                         wscrl'
> scripts/kconfig/lxdialog/checklist.c:232: warning: implicit
> declaration of function '                         wrefresh'
> scripts/kconfig/lxdialog/checklist.c:293: warning: implicit
> declaration of function '                         delwin'
> scripts/kconfig/lxdialog/checklist.c:297: error: 'KEY_LEFT' undeclared
> (first use in                          this function)
> scripts/kconfig/lxdialog/checklist.c:298: error: 'KEY_RIGHT'
> undeclared (first use in                          this function)
> scripts/kconfig/lxdialog/checklist.c:310: warning: implicit
> declaration of function '                         on_key_esc'
> scripts/kconfig/lxdialog/checklist.c:312: error: 'KEY_RESIZE'
> undeclared (first use i                         n this function)
> make[1]: *** [scripts/kconfig/lxdialog/checklist.o] Error 1
> make: *** [menuconfig] Error 2
>
> ~Akula2
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

you should install ncurses library:
---> scripts/kconfig/lxdialog/dialog.h:32:20: error: curses.h: No such file
---> or directory

good luck.
Dan Kruchinin.
