Return-Path: <linux-kernel-owner+w=401wt.eu-S1161425AbXBHFtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161425AbXBHFtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161534AbXBHFtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:49:45 -0500
Received: from raven.upol.cz ([158.194.120.4]:45784 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161425AbXBHFtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:49:45 -0500
Date: Thu, 8 Feb 2007 06:58:32 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: + search-a-little-harder-for-mkimage.patch
Message-ID: <20070208055832.GN22699@flower.upol.cz>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz> <Pine.LNX.4.64.0702080029030.14457@scrub.home> <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org> <20070207203047.51a95ad0.akpm@linux-foundation.org> <20070208052439.GL22699@flower.upol.cz> <20070207211921.1f0220a4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207211921.1f0220a4.akpm@linux-foundation.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 09:19:21PM -0800, Andrew Morton wrote:
> On Thu, 8 Feb 2007 06:24:40 +0100 Oleg Verych <olecom@flower.upol.cz> wrote:
> 
> > If that matter, `type -path' is bashizm (BloAted SHell), and "blackbox"
> > with "dash" (very good `sh' equivalents) will fail.
> 
> Does the kernel presently build with that shell?

build - yes, with dash being `$(shell)'. All scripts with `#!/bin/bash'
of course use bash, example is gen_initramfs_list.sh.

Trivial shell scripts, especially for embedded archs (Blackfin is
one, IIRC), may be easily converted.

BTW, Debian shell policy is to be bashizms-clear. Purpose -- to have
compatibility with any `sh'. Shall we?

____
