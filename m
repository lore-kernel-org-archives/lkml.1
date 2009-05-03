Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZECSBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZECSBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 14:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZECSBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 14:01:24 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35848 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZECSBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 14:01:23 -0400
Date: Sun, 3 May 2009 20:03:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Anders Kaseorg <andersk@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lots of unexpected non-allocatable section warnings
Message-ID: <20090503180332.GA31820@uranus.ravnborg.org>
References: <20090503110517.6d09bca2@hyperion.delvare> <20090503103010.GA27978@uranus.ravnborg.org> <20090503124848.276b437f@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503124848.276b437f@hyperion.delvare>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Cannot reproduce here..
> 
> Given the name of the section, I presume it is somewhat SUSE-specific.
> I'm running openSUSE 11.1.
Likely - I could not reprodcue with your config.

> > Can you send me your config so I can try to see if this is toolchain
> > version related.
> 
> Config attached.
> 
> > Also what version of gcc/binutils are you using?
> 
> $ gcc --version
> gcc (SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291]
> 
> $ ld -v
> GNU ld (GNU Binutils; openSUSE 11.1) 2.19
> 
> > Is this x86 and 32/64 bit?
> 
> x86, 64 bit. If you need anything else, let me know.

Can you send me (off-list) the .o + .ko files
for one of the failing modules.
I like to see what the section contains - or at least the flags.
I do not know on top of my head the commands so
with the .o faile available I expect to figure it out.

I obviously hope the fix also apply for powerpc - but we will
see.

	Sam
