Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZDZNJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZDZNJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbZDZNJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:09:25 -0400
Received: from ozlabs.org ([203.10.76.45]:54552 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZDZNJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:09:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v3 1/3] Make section names compatible with -ffunction-sections -fdata-sections
Date: Sun, 26 Apr 2009 22:39:16 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Tim Abbott <tabbott@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
References: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu> <1240519774-20307-1-git-send-email-tabbott@mit.edu> <20090424172358.GA21946@uranus.ravnborg.org>
In-Reply-To: <20090424172358.GA21946@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904262239.18396.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009 02:53:58 am Sam Ravnborg wrote:
> > ---
> >  Documentation/mutex-design.txt              |    4 +-
> >  arch/alpha/kernel/head.S                    |    2 +-
> ...
> >  include/linux/linkage.h                     |    4 +-
> >  include/linux/spinlock.h                    |    2 +-
> >  kernel/module.c                             |    2 +-
> >  scripts/mod/modpost.c                       |   12 ++++----
> >  scripts/recordmcount.pl                     |    6 ++--
> >  141 files changed, 356 insertions(+), 348 deletions(-)
> 
> This patch touches far too many files.
> We should try to work out a method so we are in better control
> of the section names, so renaming in the end is a simple patch
> touching only a few files.

Completely disagree.  You'll end up touching all these files, and leaving
us with now-unnecessary a level of indirection.  Also, you'll have performed
a giant pile of make-work, and bothered all the maintainers.

Just get Linus to apply the damn patch already; it's been sitting around too
long.  Then do any cleanups which are actual cleanups.

Rusty.
