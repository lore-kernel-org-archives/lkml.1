Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXBNIai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXBNIai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932168AbXBNIai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:30:38 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51568 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbXBNIah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:30:37 -0500
Date: Wed, 14 Feb 2007 09:30:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Bastian Blank <bastian@waldi.eu.org>
Subject: Re: kbuild, localversion (Re: [patch 3/3, resend] kbuild: correctly skip tilded backups in localversion files)
Message-ID: <20070214083035.GA25617@uranus.ravnborg.org>
References: <20070206011819.160359000@flower.upol.cz> <20070206012208.050237000@flower.upol.cz> <12c511ca0702121409t30e126dfh445d13dd2f637e08@mail.gmail.com> <Pine.LNX.4.64.0702121437420.8424@woody.linux-foundation.org> <20070213003258.GA15534@flower.upol.cz> <20070213050503.GA27441@flower.upol.cz> <Pine.LNX.4.64.0702130744030.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702131700190.14457@scrub.home> <20070214011644.GA13502@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214011644.GA13502@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> What i currently have is:
> 
> -- top file 'Linux.version', with first line:
> 
> 3.0.0-rcX
> which can be parsed to fill variables, used in build process (how many
> `.' and/or `-' in it -- doesn't really matter), second line is the name;
> 
> -- 'MM.version' for MM tree;
> 
> -- '[a-z]*\.version' for anything else.
> 
> usual sort will place files in right order.

Too much depend on having version in Makefile so this is a no-go to change.
This has been like this since very early days so we shall not change it.

	Sam
