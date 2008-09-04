Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYIDKgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYIDKgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYIDKgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:36:15 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:45737 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYIDKgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=db2/NBcv876lQt3qtPvwCuNwAgWhcAZNLdTIcPj4t0GgFpp9AhHMXUiVetaFUrowu4
         GdY2dKWOb7102X8l/9MoF2dV0PCtVnuEG9nI9it1KUTPNmwlu/jkfILUBVZngAHpyEEf
         EsY2w+J2UYxsjir5Dlkol/PkhmhfW/jlP6KJA=
Date: Thu, 4 Sep 2008 12:36:09 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "Nir Tzachar" <tzachar@grad120a.cs.bgu.ac.il>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Nir Tzachar <nir@tzachar.com>
Subject: Re: [PATCH] ncurses based config
Message-ID: <20080904123609.1c3638d8@Varda>
In-Reply-To: <1220469076-16487-1-git-send-email-nir@tzachar.com>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed,  3 Sep 2008 22:11:16 +0300
"Nir Tzachar" <tzachar@nexus.cs.bgu.ac.il> escribió:

> This patch was inspired by the kernel projects page, where an ncurses
> replacement for menuconfig was mentioned (by Sam Ravnborg).
> 
> Building on menuconfig, this patch implements a more modern look interface using
> ncurses and ncurses' satellite libraries (menu, panel, form). The implementation
> does not depend on lxdialog, which is currently distributed with the kernel.
> 
> The only change outside of nconf.c is due to a name clash: both ncurses and
> lkc.h define a fucntion named menu_init(). I changed the internal version's
> name. 
> 
> Please consider the patch for merging. Comments are appreciated.

  i apliedd your patches and the fixlet pointed out by Randy
  rebased on todays git and the menu crashes when i select
  help on Kernel Hacking>Spinlock and rw-...
  is a Segmentation fault

> 
> ---
>  scripts/kconfig/Makefile |   16 +-
>  scripts/kconfig/lkc.h    |    2 +-
>  scripts/kconfig/mconf.c  |    2 +
>  scripts/kconfig/menu.c   |    2 +-
>  scripts/kconfig/nconf.c  | 1852 ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 1871 insertions(+), 3 deletions(-)
>  create mode 100644 scripts/kconfig/nconf.c
> 


