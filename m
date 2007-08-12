Return-Path: <linux-kernel-owner+w=401wt.eu-S938392AbXHLUBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938392AbXHLUBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765472AbXHLUBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:01:06 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51961
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932414AbXHLUBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:01:05 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Minor fix to Documentation/powerpc/00-INDEX
Date: Sun, 12 Aug 2007 15:01:01 -0500
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, paulus@samba.org
References: <200708092342.35238.rob@landley.net> <20070811143334.60f90af4.rdunlap@xenotime.net>
In-Reply-To: <20070811143334.60f90af4.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121501.01358.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 August 2007 4:33:34 pm Randy Dunlap wrote:
> On Thu, 9 Aug 2007 23:42:35 -0500 Rob Landley wrote:
> > Signed-off-by: Rob Landley <rob@landley.net>
> >
> > I have a python script to convert 00-INDEX files into index.html files,
> > and a second script to show 404 errors in the result as well as
> > files/directories nothing links to.   (It's not very useful yet, but in
> > case you're wondering http://kernel.org/doc/docdiridx.py and
> > http://kernel.org/doc/doclinkcheck.py .)
> >
> > Anyway, my simple index.html generator breaks on the
> > Documentation/powerpc directory because one of the description lines is
> > two lines long.  This patch joins those two lines together into one line.
> >  This is the only instance (so far) of this problem.
>
> If Paul wants to merge this, then OK, but I'm not aware of any rule
> that the file descriptions inside INDEX files must be only one line
> long... is that documented somewhere?  (if so, where?)

Documentation/00-INDEX line 5:

> Please try and keep the descriptions small enough to fit on one line.

There was only one instance of it not being the case.  I can use indentation 
level instead (which is what Kconfig uses to identify help text, so I'm not 
leaking pythonisms into the kernel that aren't already there), but the one 
line thing seemed to be an existing standard.

I'm also relying on the first file in the list being documentation for 
00-INDEX itself.  (If it breaks, I'll either try to derive a new heuristic 
and change the script, or submit a patch to change the index.  That one would 
be a more difficult heuristic to replace, though.)

> Maybe the script should allow for this?

*shrug*  I can go either way on that, but people get all funny about 
whitespace being significant and the one line thing wasn't my idea. :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
