Return-Path: <linux-kernel-owner+w=401wt.eu-S1422871AbXBHCF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422871AbXBHCF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 21:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422873AbXBHCF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 21:05:57 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:32957 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422871AbXBHCF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 21:05:56 -0500
Date: Thu, 8 Feb 2007 03:05:41 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Oleg Verych <olecom@flower.upol.cz>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: discussion of Kbuild fixes (kbuild: Kbuild.include avoid using
 spaces in call arguments)
In-Reply-To: <20070208012049.GE22699@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0702080301590.14457@scrub.home>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz>
 <Pine.LNX.4.64.0702080029030.14457@scrub.home> <20070207153848.e02d355d.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702080051520.14457@scrub.home> <20070208012049.GE22699@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 8 Feb 2007, Oleg Verych wrote:

> -- `find | sort' in localversion (i insist on split between paths and
>     files)

make has dedicated functions for this.

> -- symlinks to /dev/null in option checking -- isn't it better to not
>    have any (though cached) access to files on filesystem, instead of to
>    /dev/null? cont.:

symlinks are not much else than special files.

> I wish to have more people to work on this (even with just comments),
> because "Kbuild.include" was only first step to reduce bloated top
> Makefile. Since then, it seems, Sam have more important things to do.

The problem is that you mix multiple changes into a single patch, but 
since kbuild is very central part that puts everything together, I don't 
think it's bad idea to be more conservative, especially if you just start 
to work on it.

bye, Roman
