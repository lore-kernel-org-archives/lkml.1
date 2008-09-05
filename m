Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYIENuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYIENuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYIENuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:50:03 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:42127 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbYIENuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=UlfISg6zIIJXnzqPxV4JqSsX52y80sr2Wtv6sjQCjtSO+KP3IuMl+ATBdRmXoN/lCE
         lRUvNh/AyhaSTPo4ZDxRQUU1ujLCeViGgTO0MH491tGk2u4nW+Eso/Xz5c/lGPDFPebA
         /3Ymcxw2t6c5dK2wpaWiNHKYX3a4CFjkX/b8s=
Date: Fri, 5 Sep 2008 15:49:53 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "Nir Tzachar" <tzachar@grad120a.cs.bgu.ac.il>
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, rdunlap@xenotime.net,
       kosaki.motohiro@jp.fujitsu.com, 7eggert@gmx.de,
       Nir Tzachar <nir@tzachar.com>
Subject: Re: [PATCH] ncurses based config V2
Message-ID: <20080905154953.3abefbce@Varda>
In-Reply-To: <1220603220-17090-1-git-send-email-nir@tzachar.com>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com>
	<1220603220-17090-1-git-send-email-nir@tzachar.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri,  5 Sep 2008 11:27:00 +0300
"Nir Tzachar" <tzachar@nexus.cs.bgu.ac.il> escribió:

> Changes:
> 1) Fixed segfaults in help window.
> 2) Removed the instructions window, made the instructions appear as a button
>    which displays a popup window.
> 3) Added hot keys support. As ncurses does not support several colors inside
>    a menu, keys are highlighted using "()".
> 4) Optimized for 80x24 terminals.
> 6) Fixed zconf.y to use _menu_init
> 7) added nconfig to "make help"
> 8) Misc fixes.
> 
> Comments are appreciated.
> Cheers.
> ---
>  scripts/kconfig/Makefile            |   17 +-
>  scripts/kconfig/lkc.h               |    2 +-
>  scripts/kconfig/mconf.c             |    2 +
>  scripts/kconfig/menu.c              |    2 +-
>  scripts/kconfig/nconf.c             | 2019 +++++++++++++++++++++++++++++++++++
>  scripts/kconfig/zconf.tab.c_shipped |    2 +-
>  scripts/kconfig/zconf.y             |    2 +-
>  7 files changed, 2041 insertions(+), 5 deletions(-)
>  create mode 100644 scripts/kconfig/nconf.c

 Tried it and the segmentation fault disappeared 

> 
