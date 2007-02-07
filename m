Return-Path: <linux-kernel-owner+w=401wt.eu-S965612AbXBGOhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965612AbXBGOhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXBGOhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:37:07 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:60259 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965612AbXBGOhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:37:05 -0500
Date: Wed, 7 Feb 2007 15:36:47 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Oleg Verych <olecom@flower.upol.cz>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Horst Schirmeier <horst@schirmeier.com>,
       Jan Beulich <jbeulich@novell.com>, Daniel Drake <dsd@gentoo.org>,
       Andi Kleen <ak@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch 2/3, resend] kbuild: improve option checking, Kbuild.include
 cleanup
In-Reply-To: <20070206012207.925430000@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0702071529390.14457@scrub.home>
References: <20070206011819.160359000@flower.upol.cz> <20070206012207.925430000@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 6 Feb 2007, Oleg Verych wrote:

> -- all checks by shell united in one macro -- checker-shell;
> -- one disposable output sym. link to /dev/null per shell,
>    thus no racing, `-Z' is removed;
> -- modules' build output directory is used, if supplied;
> -- every option checking function calls shell wrapper, acquires probe;
> -- `echo -e' bashizm substituted (people with sh != bash have distinct
>    CC options!);
> -- some spelling and sense added to the comments;
> -- small shuffle of whitespace.

This patch is a bit overloaded and it would be better to split it up to 
keep functional changes separate and then please drop the symlink, it has 
no advantage to a simple temp file.
Also please don't add random whitespace, Makefiles are no C files, so 
different rules apply.

bye, Roman

