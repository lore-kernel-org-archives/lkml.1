Return-Path: <linux-kernel-owner+w=401wt.eu-S966031AbZLHUYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966031AbZLHUYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965996AbZLHUX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:23:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965979AbZLHUX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:23:56 -0500
Message-ID: <4B1EB5E9.3010506@suse.cz>
Date: Tue, 08 Dec 2009 21:24:09 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       Nir Tzachar <nir.tzachar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: new kbuild maintainer
References: <1260276751-19501-1-git-send-email-mmarek@suse.cz> <200912081611.12625.a.miskiewicz@gmail.com> <4B1EAF69.5090609@suse.cz> <200912082107.19192.a.miskiewicz@gmail.com>
In-Reply-To: <200912082107.19192.a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arkadiusz Miskiewicz napsal(a):
> On Tuesday 08 of December 2009, Michal Marek wrote:
>> Arkadiusz Miskiewicz napsal(a):
>>> Maybe we can get colors back in menuconfig then? ;-)
>>> http://bugzilla.kernel.org/show_bug.cgi?id=13677
>> Does it also happen with Nir's nconfig
>> (http://lkml.org/lkml/2009/11/25/119)?
> 
> Yes, it does happen, I have non-color menus. That's because nconfig also mixes 
> wide ncurses library with non wide ncurses headers.
> 
>   gcc -Wp,-MD,scripts/kconfig/.nconf.o.d -Wall -Wmissing-prototypes -Wstrict-
> prototypes -O2 -fomit-frame-pointer   -I/usr/include/ncurses -
> DCURSES_LOC="<ncurses.h>" -DLOCALE   -c -o scripts/kconfig/nconf.o 
> scripts/kconfig/nconf.c
> 
> /usr/include/ncurses is non wide version of ncurses headers (but on other 
> distros it could be done differently aka /usr/include/ncures being wide 
> version)
> 
>   gcc  -o scripts/kconfig/nconf scripts/kconfig/nconf.o 
> scripts/kconfig/zconf.tab.o scripts/kconfig/nconf.gui.o -lncursesw -lmenu -
> lpanel -lncurses
> 
> and here it's linked to non wide version of library (also to wide, too due to 
> scripts/kconfig/lxdialog/check-lxdialog.sh putting it here)
> 
> Anyway way to solve this is:
> - detect if ncurses header is wide or non-wide
> - link with proper ncurses library based on detected header

Nir, you surely know ncurses better than me :). Could you look into
this?   Arkadiusz, which distribution are you using?

Michal
