Return-Path: <linux-kernel-owner+w=401wt.eu-S937665AbXHLUQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937665AbXHLUQx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761056AbXHLUQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:16:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:33826 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbXHLUQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mtSrA1UuVx002h+MYCobNtUWGd7kNnAbwfc2St2eBXXWL8VzAeH0gM1oio9+QXCZjsStj/xIbUIVfPAmBiZLUbKAV/QuaDdbKBdxAu0b1IQvoaD7lWjYP7QM6NSNcwYvcFJhLWtZ0KdHNGAPfXXQGZocxggGTCNpePo8yZC1bOw=
Message-ID: <9a8748490708121316s4312e273me8940c0bbd8d00d1@mail.gmail.com>
Date: Sun, 12 Aug 2007 22:16:43 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [PATCH] Minor fix to Documentation/powerpc/00-INDEX
Cc: "Randy Dunlap" <rdunlap@xenotime.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <200708121501.01358.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708092342.35238.rob@landley.net>
	 <20070811143334.60f90af4.rdunlap@xenotime.net>
	 <200708121501.01358.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/07, Rob Landley <rob@landley.net> wrote:
> On Saturday 11 August 2007 4:33:34 pm Randy Dunlap wrote:
> > On Thu, 9 Aug 2007 23:42:35 -0500 Rob Landley wrote:
> > > Signed-off-by: Rob Landley <rob@landley.net>
> > >
> > > I have a python script to convert 00-INDEX files into index.html files,
> > > and a second script to show 404 errors in the result as well as
> > > files/directories nothing links to.   (It's not very useful yet, but in
> > > case you're wondering http://kernel.org/doc/docdiridx.py and
> > > http://kernel.org/doc/doclinkcheck.py .)
> > >
> > > Anyway, my simple index.html generator breaks on the
> > > Documentation/powerpc directory because one of the description lines is
> > > two lines long.  This patch joins those two lines together into one line.
> > >  This is the only instance (so far) of this problem.
> >
> > If Paul wants to merge this, then OK, but I'm not aware of any rule
> > that the file descriptions inside INDEX files must be only one line
> > long... is that documented somewhere?  (if so, where?)
>
> Documentation/00-INDEX line 5:
>
> > Please try and keep the descriptions small enough to fit on one line.
>
> There was only one instance of it not being the case.  I can use indentation
> level instead (which is what Kconfig uses to identify help text, so I'm not
> leaking pythonisms into the kernel that aren't already there), but the one
> line thing seemed to be an existing standard.
>
The two times that I've done some big updates to
Documentation/00-INDEX I've also stuck to one line for each
description since that was the only form I'd ever seen - I didn't know
if it was a rule or not, but it seemed pretty sensible for an index.
It's also the form I've stuck to for the new files I send patches for recently.

So for whatever my oppinion is worth; I think we may as well make it a
rule for the 00-INDEX files.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
