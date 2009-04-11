Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZDKFnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZDKFnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 01:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZDKFnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 01:43:14 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42417 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZDKFnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 01:43:13 -0400
Date: Sat, 11 Apr 2009 07:45:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jike Song <albcamus@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, torvalds@osdl.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MN10300: Move arch headers to arch dir
Message-ID: <20090411054516.GA29493@uranus.ravnborg.org>
References: <19057.1239370935@redhat.com> <20090410192529.GA25551@uranus.ravnborg.org> <df9815e70904102042r2cd2e3e3ue6159f348e4c192e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9815e70904102042r2cd2e3e3ue6159f348e4c192e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 11:42:01AM +0800, Jike Song wrote:
> On Sat, Apr 11, 2009 at 3:25 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > .gitignore is left in include/asm-mn10300.
> >
> > As the content of that file is obsoleted by your last patch it can safely be deleted.
> > Linus - can I ask you to do so?
> >
> >        Sam
> 
> off topic: there is also a .gitignore left in include/asm-arm.
But its there for a reason.
Arm generates mach-types.h and it should be ignored.

include/asm-arm is no longer a sensible place for these files,
but for now I have no better place for them so they will
stay there for a while.

	Sam
