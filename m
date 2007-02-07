Return-Path: <linux-kernel-owner+w=401wt.eu-S1161022AbXBGRr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161022AbXBGRr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161403AbXBGRr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:47:29 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:60509 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161022AbXBGRr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:47:28 -0500
Date: Wed, 7 Feb 2007 18:47:15 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: olecom@flower.upol.cz, torvalds@osdl.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: -mcpu strikes back
In-Reply-To: <20070207165204.GA5537@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702071846180.14457@scrub.home>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 7 Feb 2007, Alexey Dobriyan wrote:

> The change below is shitting i386 defconfig (as well as my usual config)
> build log with warnings:
> 
>   CC      init/main.o
> `-mcpu=' is deprecated. Use `-mtune=' or '-march=' instead.
> `-mcpu=' is deprecated. Use `-mtune=' or '-march=' instead.
> 
> gcc is 4.1.1.
> 
> ------------------
> $ git-cat-file commit 5de043f4bd11a9e0a3e8daec7d1905da575a76b7
> tree 1cdafacd6a0f6e12bd5b88d9031a6130169ca868
> parent f6112ec27a8f0eee6c5a996f65c7bfd9457d9f85
> author Oleg Verych <olecom@flower.upol.cz> 1170724701 +0100
> committer Linus Torvalds <torvalds@woody.linux-foundation.org>
> 1170801049 -0800
> 
> [PATCH] kbuild: improve option checking, Kbuild.include cleanup
> 
>  GNU binutils, root users, tmpfiles, external modules ro builds must
>  be fixed to do the right thing now.

Linus, please revert. Thanks.

bye, Roman
