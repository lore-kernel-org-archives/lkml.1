Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZDRUxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZDRUxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZDRUxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:53:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33342 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZDRUxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:53:42 -0400
Date: Sat, 18 Apr 2009 21:53:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Russell King <rmk+lkml@arm.linux.org.uk>,
       takata@linux-m32r.org, Christoph Hellwig <hch@lst.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: use include/gen for mach-types.h
Message-ID: <20090418205318.GT26366@ZenIV.linux.org.uk>
References: <20090416150707.GA941@lst.de> <20090416164050.GB4850@uranus.ravnborg.org> <swfmyag9fx8.wl%takata.hirokazu@renesas.com> <alpine.LFD.2.00.0904171034140.4042@localhost.localdomain> <20090417221440.GA16791@uranus.ravnborg.org> <20090418101444.GA9768@flint.arm.linux.org.uk> <20090418181714.GA25786@uranus.ravnborg.org> <alpine.LFD.2.00.0904181226170.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904181226170.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 12:28:51PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 18 Apr 2009, Sam Ravnborg wrote:
> >
> > diff --git a/include/gen/.gitignore b/include/gen/.gitignore
> > new file mode 100644
> > index 0000000..1e809fd
> > --- /dev/null
> > +++ b/include/gen/.gitignore
> > @@ -0,0 +1,2 @@
> > +# mach-types.h is used by arm
> > +mach-types.h
> 
> I think this is bad.
> 
> The whole point of having 'include/gen' should be that _all_ files in that 
> directory should be generated. So it should be include/.gitignore that 
> just contains the pattern "gen/" and that's it.

Or .gitignore in top-level, same as for include/config
