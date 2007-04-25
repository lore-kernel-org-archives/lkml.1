Return-Path: <linux-kernel-owner+w=401wt.eu-S1030924AbXDYOhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030924AbXDYOhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161478AbXDYOhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:37:00 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:23640 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030934AbXDYOg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:36:59 -0400
Message-ID: <462F6788.1040806@msgid.tls.msk.ru>
Date: Wed, 25 Apr 2007 18:36:56 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Sunil Naidu <akula2.shark@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: menuconfig issue (checklist) in 2.6.20.7 & 2.6.21-rc7 ?
References: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
In-Reply-To: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sunil Naidu wrote:
> Hello,
> 
> I was trying to compile those kernels with make menuconfig. I am
> getting the error in scripts/kconfig/lxdialog/checklist.o. Here is the
> output:
> 
> [sukhoi@Akula2 linux-2.6.20.7]$ sudo make menuconfig

Don't compile kernel as root.

>  HOSTCC  scripts/kconfig/lxdialog/checklist.o
> In file included from scripts/kconfig/lxdialog/checklist.c:24:
> scripts/kconfig/lxdialog/dialog.h:32:20: error: curses.h: No such file or directory

And before doing make menuconfig, install ncurses package (both
the library and development files).

/mjt
