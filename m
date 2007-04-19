Return-Path: <linux-kernel-owner+w=401wt.eu-S1766827AbXDSPvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766827AbXDSPvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766829AbXDSPvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:51:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37281 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766828AbXDSPvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:51:00 -0400
Date: Thu, 19 Apr 2007 08:53:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bbpetkov@yahoo.de
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Message-Id: <20070419085336.c029b87c.randy.dunlap@oracle.com>
In-Reply-To: <20070419062059.GA3974@gollum.tnic>
References: <20070413091422.GA15426@zmei.tnic>
	<20070414091341.7665d8b0.randy.dunlap@oracle.com>
	<20070415071050.GA4002@gollum.tnic>
	<20070417104907.GA6155@gollum.tnic>
	<20070418090320.3786edd6.randy.dunlap@oracle.com>
	<20070419062059.GA3974@gollum.tnic>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 08:20:59 +0200 Borislav Petkov wrote:

> <snip>
> > > I'm pretty sure the reason you cannot reproduce this warning is the line 
> > > 
> > > <xsl:param name="refentry.version.suppress">1</xsl:param>
> > > 
> > > which can be found in param.xsl, it being a part of the docbook-xsl
> > > distribution. The parameter's name is self-explanatory and a '1' suppresses
> > > the version generation. I was able to get this error because in the
> > > debian docbook-xsl package this param value is set to 0 by default.
> > 
> > Hm, I don't seem to have that file installed (except in
> > /usr/share/xml/docbook/stylesheet/...).  Where would it normally
> > be installed?
> 
> /usr/share/xml/docbook/stylesheet/nwalsh/manpages/param.xsl here

OK, I have that one, with a /current/ stuck in there:


/usr/share/xml/docbook/stylesheet/nwalsh/1.69.1/manpages/param.xsl

<xsl:param name="refentry.version.suppress">0</xsl:param>


> > > This means, some users will get this warning and some will not, depending on the
> > > setting in the param.xsl file. What is the way to go here wrt to a solution
> > > dealing with all cases:
> > > 
> > > 1. patch the kernel-doc?
> > > 2. issue an info so that the user can suppress the annoying warning by
> > > themselves?
> > > 3. ...?
> > 
> > 
> > Are other people seeing these warning messages ??
> Hm, is anyone building the manpages target at all?

Other than the 2 of us... I couldn't say.

> > If so, I think that we should patch the kernel-doc.  I don't think
> > that many people would read info about how to avoid the warnings.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
