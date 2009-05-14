Return-Path: <linux-kernel-owner+w=401wt.eu-S1761543AbZENGOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbZENGOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 02:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZENGON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 02:14:13 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:48175 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZENGOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 02:14:12 -0400
Date: Thu, 14 May 2009 08:16:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH 01/15] asm-generic: rename termios.h, signal.h and mman.h
Message-ID: <20090514061623.GA27755@uranus.ravnborg.org>
References: <1242255398-23779-1-git-send-email-arnd@arndb.de> <1242255398-23779-2-git-send-email-arnd@arndb.de> <20090514151107.5eae120e.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514151107.5eae120e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 03:11:07PM +1000, Stephen Rothwell wrote:
> Hi Arnd,
> 
> On Wed, 13 May 2009 22:56:24 +0000 Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > --- a/include/asm-generic/Kbuild
> > +++ b/include/asm-generic/Kbuild
> > @@ -2,9 +2,9 @@ header-y += errno-base.h
> >  header-y += errno.h
> >  header-y += fcntl.h
> >  header-y += ioctl.h
> > -header-y += mman.h
> > +header-y += mman-common.h
> >  header-y += poll.h
> > -header-y += signal.h
> > +header-y += signal-defs.h
> >  header-y += statfs.h
> 
> I think that this change will prevent asm/mman.h and asm/signal.h from
> being exported from the arch include/asm directories.
> include/asm-generic/Kbuild is included by the arch/*/include/asm/Kbuild
> files.

We have two Kbuild files in asm-generic.

Kbuild (the one patched above) which specifies the files to be exported from asm-generic.
Kbuild.asm which specify the commen set of files all architctures hall export.

The latter is the file included from the arch's Kbuild file.

I'm not sure this answer/address your comment above...

	Sam
