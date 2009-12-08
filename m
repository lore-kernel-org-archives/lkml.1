Return-Path: <linux-kernel-owner+w=401wt.eu-S937878AbZLHUb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937878AbZLHUb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936711AbZLHUbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:31:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:62993 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935789AbZLHUbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:31:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=cdoWbnZWohxQljILwTJGyYJ4fh7Wa5EWJfsBl6gb6UfJ60YYx7xlL1MmDt5HF5UT4y
         2H2hMlotkPYnmnbcVdoU+6ECfszC7ykfxaW+UomOFwkRbclkCFoFwjYLrKTRTo5tJhWR
         6HXvl8itRtH5Y/luEX6AXrxJv/xq3O5Vxq1Gc=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] MAINTAINERS: new kbuild maintainer
Date: Tue, 8 Dec 2009 21:31:25 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-00908-g6ec22f9; KDE/4.3.4; x86_64; ; )
Cc: Nir Tzachar <nir.tzachar@gmail.com>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
References: <1260276751-19501-1-git-send-email-mmarek@suse.cz> <200912082107.19192.a.miskiewicz@gmail.com> <4B1EB5E9.3010506@suse.cz>
In-Reply-To: <4B1EB5E9.3010506@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912082131.26051.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 of December 2009, Michal Marek wrote:
> Arkadiusz Miskiewicz napsal(a):
> > On Tuesday 08 of December 2009, Michal Marek wrote:
> >> Arkadiusz Miskiewicz napsal(a):
> >>> Maybe we can get colors back in menuconfig then? ;-)
> >>> http://bugzilla.kernel.org/show_bug.cgi?id=13677
> >>
> >> Does it also happen with Nir's nconfig
> >> (http://lkml.org/lkml/2009/11/25/119)?
> >
> > Yes, it does happen, I have non-color menus. That's because nconfig also
> > mixes wide ncurses library with non wide ncurses headers.
> >
> >   gcc -Wp,-MD,scripts/kconfig/.nconf.o.d -Wall -Wmissing-prototypes
> > -Wstrict- prototypes -O2 -fomit-frame-pointer   -I/usr/include/ncurses -
> > DCURSES_LOC="<ncurses.h>" -DLOCALE   -c -o scripts/kconfig/nconf.o
> > scripts/kconfig/nconf.c
> >
> > /usr/include/ncurses is non wide version of ncurses headers (but on other
> > distros it could be done differently aka /usr/include/ncures being wide
> > version)
> >
> >   gcc  -o scripts/kconfig/nconf scripts/kconfig/nconf.o
> > scripts/kconfig/zconf.tab.o scripts/kconfig/nconf.gui.o -lncursesw -lmenu
> > - lpanel -lncurses
> >
> > and here it's linked to non wide version of library (also to wide, too
> > due to scripts/kconfig/lxdialog/check-lxdialog.sh putting it here)
> >
> > Anyway way to solve this is:
> > - detect if ncurses header is wide or non-wide
> > - link with proper ncurses library based on detected header
> 
> Nir, you surely know ncurses better than me :). Could you look into
> this?   Arkadiusz, which distribution are you using?

PLD/Linux

> Michal

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
