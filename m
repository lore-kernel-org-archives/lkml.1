Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZDKGn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZDKGn1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 02:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZDKGnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 02:43:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54029 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZDKGnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 02:43:17 -0400
Date: Sat, 11 Apr 2009 07:43:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jike Song <albcamus@gmail.com>, David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MN10300: Move arch headers to arch dir
Message-ID: <20090411064300.GT26366@ZenIV.linux.org.uk>
References: <19057.1239370935@redhat.com> <20090410192529.GA25551@uranus.ravnborg.org> <df9815e70904102042r2cd2e3e3ue6159f348e4c192e@mail.gmail.com> <20090411054516.GA29493@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411054516.GA29493@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 07:45:16AM +0200, Sam Ravnborg wrote:
> On Sat, Apr 11, 2009 at 11:42:01AM +0800, Jike Song wrote:
> > On Sat, Apr 11, 2009 at 3:25 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > >
> > > .gitignore is left in include/asm-mn10300.
> > >
> > > As the content of that file is obsoleted by your last patch it can safely be deleted.
> > > Linus - can I ask you to do so?
> > >
> > >        Sam
> > 
> > off topic: there is also a .gitignore left in include/asm-arm.
> But its there for a reason.
> Arm generates mach-types.h and it should be ignored.
> 
> include/asm-arm is no longer a sensible place for these files,
> but for now I have no better place for them so they will
> stay there for a while.

How about a single directory for *all* generated headers?  Only linux/version.h
has many places including it and even that can be dealt with for a moment with
linux/version.h consisting of #include <gen/version.h>.  The rest doesn't
need anything like that even for transition period - too few includes to care.
