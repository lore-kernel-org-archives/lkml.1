Return-Path: <linux-kernel-owner+w=401wt.eu-S938506AbXHLVvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938506AbXHLVvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 17:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762644AbXHLVvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 17:51:38 -0400
Received: from xenotime.net ([66.160.160.81]:38936 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762067AbXHLVvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 17:51:37 -0400
Date: Sun, 12 Aug 2007 14:57:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Rob Landley" <rob@landley.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] Minor fix to Documentation/powerpc/00-INDEX
Message-Id: <20070812145737.ff5dd3b0.rdunlap@xenotime.net>
In-Reply-To: <9a8748490708121316s4312e273me8940c0bbd8d00d1@mail.gmail.com>
References: <200708092342.35238.rob@landley.net>
	<20070811143334.60f90af4.rdunlap@xenotime.net>
	<200708121501.01358.rob@landley.net>
	<9a8748490708121316s4312e273me8940c0bbd8d00d1@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 22:16:43 +0200 Jesper Juhl wrote:

> On 12/08/07, Rob Landley <rob@landley.net> wrote:
> > On Saturday 11 August 2007 4:33:34 pm Randy Dunlap wrote:
> > > On Thu, 9 Aug 2007 23:42:35 -0500 Rob Landley wrote:
> > > > Signed-off-by: Rob Landley <rob@landley.net>
> > > >
> > > > I have a python script to convert 00-INDEX files into index.html files,
> > > > and a second script to show 404 errors in the result as well as
> > > > files/directories nothing links to.   (It's not very useful yet, but in
> > > > case you're wondering http://kernel.org/doc/docdiridx.py and
> > > > http://kernel.org/doc/doclinkcheck.py .)
> > > >
> > > > Anyway, my simple index.html generator breaks on the
> > > > Documentation/powerpc directory because one of the description lines is
> > > > two lines long.  This patch joins those two lines together into one line.
> > > >  This is the only instance (so far) of this problem.
> > >
> > > If Paul wants to merge this, then OK, but I'm not aware of any rule
> > > that the file descriptions inside INDEX files must be only one line
> > > long... is that documented somewhere?  (if so, where?)
> >
> > Documentation/00-INDEX line 5:
> >
> > > Please try and keep the descriptions small enough to fit on one line.

OK :)

> > There was only one instance of it not being the case.  I can use indentation
> > level instead (which is what Kconfig uses to identify help text, so I'm not
> > leaking pythonisms into the kernel that aren't already there), but the one
> > line thing seemed to be an existing standard.
> >
> The two times that I've done some big updates to
> Documentation/00-INDEX I've also stuck to one line for each
> description since that was the only form I'd ever seen - I didn't know
> if it was a rule or not, but it seemed pretty sensible for an index.
> It's also the form I've stuck to for the new files I send patches for recently.
> 
> So for whatever my oppinion is worth; I think we may as well make it a
> rule for the 00-INDEX files.

I think that it's a reasonable rule.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
