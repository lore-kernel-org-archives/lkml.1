Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYICTm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYICTm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYICTmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:42:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:19523 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYICTmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=NIn8dlOAePlD9YTh6WbR8JCm0uIgzJrzw/w/ou/eFoetj5V0qY3bMJy1qOzYb8sCzR
         VZVzV1+r2kaEt7g2B1DuO2UcG0hBXW10pf/Bx63r1VlTahtNJlpwXkc0cEYq8ldZ/RR/
         coIxqV9JEiGnZxfvEL2/tNnaLLKRudOVR2Gr8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Nir Tzachar" <tzachar@grad120a.cs.bgu.ac.il>
Subject: Re: [PATCH] ncurses based config
Date: Wed, 3 Sep 2008 21:38:14 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Nir Tzachar <nir@tzachar.com>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com>
In-Reply-To: <1220469076-16487-1-git-send-email-nir@tzachar.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809032138.14651.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 03 September 2008, Nir Tzachar wrote:
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

Could you please tell what kernel version is it against?

I'm getting the following error on make nconfig (and also on make menuconfig
which works fine without this patch) with the current Linus' tree:

  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  HOSTCC  scripts/kconfig/nconf.o
  HOSTCC  scripts/kconfig/zconf.tab.o
scripts/kconfig/zconf.tab.c: In function ‘conf_parse’:
scripts/kconfig/zconf.tab.c:2258: warning: implicit declaration of function ‘menu_init’
  HOSTLD  scripts/kconfig/nconf
scripts/kconfig/nconf arch/x86/Kconfig
make[1]: *** [nconfig] Segmentation fault
make: *** [nconfig] Error 2
