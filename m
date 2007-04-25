Return-Path: <linux-kernel-owner+w=401wt.eu-S1030908AbXDYOYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030908AbXDYOYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030924AbXDYOYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:24:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:7986 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030908AbXDYOYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:24:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VfSunfIAwpf7Yxx64+50B2oaK6jUgCrNuV6BlWiE3r6DPDvpBxcH9aFyBxzIor8zIykFZhQHDMMNtn0X2jp0zOpCGu5EZqT4WnjGA8ft5/AIDrxqRLkVbdBAwvaRmpPsZ+bXl/kTrW5RInf61yPvLLnpXJr2TepJMSvfDFIQkpA=
Message-ID: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
Date: Wed, 25 Apr 2007 19:54:14 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: menuconfig issue (checklist) in 2.6.20.7 & 2.6.21-rc7 ?
Cc: "Andrew Morton" <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was trying to compile those kernels with make menuconfig. I am
getting the error in scripts/kconfig/lxdialog/checklist.o. Here is the
output:

[sukhoi@Akula2 linux-2.6.20.7]$ sudo make menuconfig
  HOSTCC  scripts/kconfig/lxdialog/checklist.o
In file included from scripts/kconfig/lxdialog/checklist.c:24:
scripts/kconfig/lxdialog/dialog.h:32:20: error: curses.h: No such file
or directory
In file included from scripts/kconfig/lxdialog/checklist.c:24:
scripts/kconfig/lxdialog/dialog.h:97: error: expected
specifier-qualifier-list before
 'chtype'
scripts/kconfig/lxdialog/dialog.h:187: error: expected ')' before '*' token
scripts/kconfig/lxdialog/dialog.h:193: error: expected ')' before '*' token
scripts/kconfig/lxdialog/dialog.h:195: error: expected ')' before '*' token
scripts/kconfig/lxdialog/dialog.h:196: error: expected ')' before '*' token
scripts/kconfig/lxdialog/dialog.h:197: error: expected ')' before '*' token
scripts/kconfig/lxdialog/dialog.h:198: error: expected ')' before '*' token
scripts/kconfig/lxdialog/dialog.h:200: error: expected ')' before '*' token
scripts/kconfig/lxdialog/checklist.c:31: error: expected ')' before '*' token
scripts/kconfig/lxdialog/checklist.c:59: error: expected ')' before '*' token
scripts/kconfig/lxdialog/checklist.c:95: error: expected ')' before '*' token
scripts/kconfig/lxdialog/checklist.c: In function 'dialog_checklist':
scripts/kconfig/lxdialog/checklist.c:116: error: 'WINDOW' undeclared
(first use in th
is function)
scripts/kconfig/lxdialog/checklist.c:116: error: (Each undeclared
identifier is repor
ted only once
scripts/kconfig/lxdialog/checklist.c:116: error: for each function it
appears in.)
scripts/kconfig/lxdialog/checklist.c:116: error: 'dialog' undeclared
(first use in th
is function)
scripts/kconfig/lxdialog/checklist.c:116: error: 'list' undeclared
(first use in this
 function)
scripts/kconfig/lxdialog/checklist.c:116: warning: left-hand operand
of comma express
ion has no effect
scripts/kconfig/lxdialog/checklist.c:129: warning: implicit
declaration of function '
getmaxy'
scripts/kconfig/lxdialog/checklist.c:129: error: 'stdscr' undeclared
(first use in th
is function)
scripts/kconfig/lxdialog/checklist.c:130: error: 'KEY_MAX' undeclared
(first use in t
his function)
scripts/kconfig/lxdialog/checklist.c:131: warning: implicit
declaration of function '
getmaxx'
scripts/kconfig/lxdialog/checklist.c:137: error: 'COLS' undeclared
(first use in this
 function)
scripts/kconfig/lxdialog/checklist.c:138: error: 'LINES' undeclared
(first use in thi
s function)
scripts/kconfig/lxdialog/checklist.c:140: warning: implicit
declaration of function '
draw_shadow'
scripts/kconfig/lxdialog/checklist.c:142: warning: implicit
declaration of function '
newwin'
scripts/kconfig/lxdialog/checklist.c:143: warning: implicit
declaration of function '
keypad'
scripts/kconfig/lxdialog/checklist.c:143: error: 'TRUE' undeclared
(first use in this
 function)
scripts/kconfig/lxdialog/checklist.c:145: warning: implicit
declaration of function '
draw_box'
scripts/kconfig/lxdialog/checklist.c:146: error: 'struct dialog_color'
has no member
named 'atr'
scripts/kconfig/lxdialog/checklist.c:146: error: 'struct dialog_color'
has no member
named 'atr'
scripts/kconfig/lxdialog/checklist.c:147: warning: implicit
declaration of function '
wattrset'
scripts/kconfig/lxdialog/checklist.c:147: error: 'struct dialog_color'
has no member
named 'atr'
scripts/kconfig/lxdialog/checklist.c:148: warning: implicit
declaration of function '
mvwaddch'
scripts/kconfig/lxdialog/checklist.c:150: warning: implicit
declaration of function '
waddch'
scripts/kconfig/lxdialog/checklist.c:151: error: 'struct dialog_color'
has no member
named 'atr'
scripts/kconfig/lxdialog/checklist.c:154: warning: implicit
declaration of function '
print_title'
scripts/kconfig/lxdialog/checklist.c:156: error: 'struct dialog_color'
has no member
named 'atr'
scripts/kconfig/lxdialog/checklist.c:157: warning: implicit
declaration of function '
print_autowrap'
scripts/kconfig/lxdialog/checklist.c:164: warning: implicit
declaration of function '
subwin'
scripts/kconfig/lxdialog/checklist.c:171: error: 'struct dialog_color'
has no member
named 'atr'
scripts/kconfig/lxdialog/checklist.c:171: error: 'struct dialog_color'
has no member
named 'atr'
scripts/kconfig/lxdialog/checklist.c:189: warning: implicit
declaration of function '
print_item'
scripts/kconfig/lxdialog/checklist.c:192: warning: implicit
declaration of function '
print_arrows'
scripts/kconfig/lxdialog/checklist.c:195: warning: implicit
declaration of function '
print_buttons'
scripts/kconfig/lxdialog/checklist.c:197: warning: implicit
declaration of function '
wnoutrefresh'
scripts/kconfig/lxdialog/checklist.c:199: warning: implicit
declaration of function '
doupdate'
scripts/kconfig/lxdialog/checklist.c:202: warning: implicit
declaration of function '
wgetch'
scripts/kconfig/lxdialog/checklist.c:210: error: 'KEY_UP' undeclared
(first use in th                         is function)
scripts/kconfig/lxdialog/checklist.c:210: error: 'KEY_DOWN' undeclared
(first use in                          this function)
scripts/kconfig/lxdialog/checklist.c:220: error: 'FALSE' undeclared
(first use in thi                         s function)
scripts/kconfig/lxdialog/checklist.c:221: warning: implicit
declaration of function '                         scrollok'
scripts/kconfig/lxdialog/checklist.c:222: warning: implicit
declaration of function '                         wscrl'
scripts/kconfig/lxdialog/checklist.c:232: warning: implicit
declaration of function '                         wrefresh'
scripts/kconfig/lxdialog/checklist.c:293: warning: implicit
declaration of function '                         delwin'
scripts/kconfig/lxdialog/checklist.c:297: error: 'KEY_LEFT' undeclared
(first use in                          this function)
scripts/kconfig/lxdialog/checklist.c:298: error: 'KEY_RIGHT'
undeclared (first use in                          this function)
scripts/kconfig/lxdialog/checklist.c:310: warning: implicit
declaration of function '                         on_key_esc'
scripts/kconfig/lxdialog/checklist.c:312: error: 'KEY_RESIZE'
undeclared (first use i                         n this function)
make[1]: *** [scripts/kconfig/lxdialog/checklist.o] Error 1
make: *** [menuconfig] Error 2

~Akula2
