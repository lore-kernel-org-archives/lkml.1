Return-Path: <linux-kernel-owner+w=401wt.eu-S1030952AbXDVXFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030952AbXDVXFD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030953AbXDVXFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:05:03 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29629 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030952AbXDVXFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:05:00 -0400
Message-ID: <7329289.1177283098453.JavaMail.oracle@web265.oracle.com>
Date: Sun, 22 Apr 2007 23:04:58 +0000 (GMT)
From: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>
To: bbpetkov@yahoo.de
Subject: Re: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Cc: lkml <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




---
~Randy


--- Original Message ---
> On Thu, Apr 19, 2007 at 08:53:36AM -0700, Randy Dunlap wrote:
> > On Thu, 19 Apr 2007 08:20:59 +0200 Borislav Petkov wrote:
> > 
> > > <snip>
> > > > > I'm pretty sure the reason you cannot reproduce this warning is the line 
> > > > > 
> > > > > <xsl:param name="refentry.version.suppress">1</xsl:param>
> > > > > 
> > > > > which can be found in param.xsl, it being a part of the docbook-xsl
> > > > > distribution. The parameter's name is self-explanatory and a '1' suppresses
> > > > > the version generation. I was able to get this error because in the
> > > > > debian docbook-xsl package this param value is set to 0 by default.
> > > > 
> > > > Hm, I don't seem to have that file installed (except in
> > > > /usr/share/xml/docbook/stylesheet/...).  Where would it normally
> > > > be installed?
> > > 
> > > /usr/share/xml/docbook/stylesheet/nwalsh/manpages/param.xsl here
> > 
> > OK, I have that one, with a /current/ stuck in there:
> > 
> > 
> > /usr/share/xml/docbook/stylesheet/nwalsh/1.69.1/manpages/param.xsl
> > 
> > <xsl:param name="refentry.version.suppress">0</xsl:param>
> 
> That's why you don't get the warnings.
> 
> > > > > This means, some users will get this warning and some will not, depending on the
> > > > > setting in the param.xsl file. What is the way to go here wrt to a solution
> > > > > dealing with all cases:
> > > > > 
> > > > > 1. patch the kernel-doc?
> > > > > 2. issue an info so that the user can suppress the annoying warning by
> > > > > themselves?
> > > > > 3. ...?
> > > > 
> > > > 
> > > > Are other people seeing these warning messages ??
> > > Hm, is anyone building the manpages target at all?
> > 
> > Other than the 2 of us... I couldn't say.
> 
> By the way, can we consider the item 
> "- clean up Documentation/DocBook/, fix warnings that occur
> on make *docs."  
> from the KJ TODO list as now done?

i'm traveling atm  i'll check on that next week.


> > > > If so, I think that we should patch the kernel-doc.  I don't think
> > > > that many people would read info about how to avoid the warnings.
> > 
> > 
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> -- 
> Regards/Gruß,
>     Boris.

