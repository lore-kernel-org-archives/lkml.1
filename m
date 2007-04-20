Return-Path: <linux-kernel-owner+w=401wt.eu-S1422919AbXDTGCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422919AbXDTGCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 02:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422947AbXDTGCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 02:02:54 -0400
Received: from smtp109.plus.mail.re2.yahoo.com ([206.190.53.34]:35477 "HELO
	smtp109.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422919AbXDTGCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 02:02:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=wOBpFnDnoOk4556wLZgJPeJ38193L8G5Tf6fLep5zPctsRZx7b04jv6PUuyOuEzW4jvA0WTxDIhCd91zFGFpi8/E8KGkGOEkJN6IoLTnYtnbAL5o0Okq+rcQggfs1FkWYbuYANtH7p0Pj1efHyEvN1hPGjW42R8ooJ++eVHjOMc=  ;
X-YMail-OSG: FsCGWGAVM1n4y8OjoD6foH6QrrIef2xdu001LXWgP04VR.OAJyea3NHkP0gbHUtTun0bGU_dfg--
Date: Fri, 20 Apr 2007 08:02:50 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Message-ID: <20070420060250.GB3967@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070413091422.GA15426@zmei.tnic> <20070414091341.7665d8b0.randy.dunlap@oracle.com> <20070415071050.GA4002@gollum.tnic> <20070417104907.GA6155@gollum.tnic> <20070418090320.3786edd6.randy.dunlap@oracle.com> <20070419062059.GA3974@gollum.tnic> <20070419085336.c029b87c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070419085336.c029b87c.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 08:53:36AM -0700, Randy Dunlap wrote:
> On Thu, 19 Apr 2007 08:20:59 +0200 Borislav Petkov wrote:
> 
> > <snip>
> > > > I'm pretty sure the reason you cannot reproduce this warning is the line 
> > > > 
> > > > <xsl:param name="refentry.version.suppress">1</xsl:param>
> > > > 
> > > > which can be found in param.xsl, it being a part of the docbook-xsl
> > > > distribution. The parameter's name is self-explanatory and a '1' suppresses
> > > > the version generation. I was able to get this error because in the
> > > > debian docbook-xsl package this param value is set to 0 by default.
> > > 
> > > Hm, I don't seem to have that file installed (except in
> > > /usr/share/xml/docbook/stylesheet/...).  Where would it normally
> > > be installed?
> > 
> > /usr/share/xml/docbook/stylesheet/nwalsh/manpages/param.xsl here
> 
> OK, I have that one, with a /current/ stuck in there:
> 
> 
> /usr/share/xml/docbook/stylesheet/nwalsh/1.69.1/manpages/param.xsl
> 
> <xsl:param name="refentry.version.suppress">0</xsl:param>

That's why you don't get the warnings.

> > > > This means, some users will get this warning and some will not, depending on the
> > > > setting in the param.xsl file. What is the way to go here wrt to a solution
> > > > dealing with all cases:
> > > > 
> > > > 1. patch the kernel-doc?
> > > > 2. issue an info so that the user can suppress the annoying warning by
> > > > themselves?
> > > > 3. ...?
> > > 
> > > 
> > > Are other people seeing these warning messages ??
> > Hm, is anyone building the manpages target at all?
> 
> Other than the 2 of us... I couldn't say.

By the way, can we consider the item 
"- clean up Documentation/DocBook/, fix warnings that occur on make *docs."  
from the KJ TODO list as now done?
 
> > > If so, I think that we should patch the kernel-doc.  I don't think
> > > that many people would read info about how to avoid the warnings.
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

-- 
Regards/Gruﬂ,
    Boris.
