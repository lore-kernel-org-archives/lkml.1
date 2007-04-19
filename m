Return-Path: <linux-kernel-owner+w=401wt.eu-S1031159AbXDSGgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031159AbXDSGgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031154AbXDSGgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:36:18 -0400
Received: from smtp102.plus.mail.mud.yahoo.com ([68.142.206.235]:25579 "HELO
	smtp102.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031159AbXDSGgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:36:17 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2007 02:36:17 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=qyq74uoVKggrG35m/WKp2zqzaU1KUeVMn7nDsumtWpe8IpamUVGKxh23MXI5RWdoRVn8Qhdq6JQhiQwaL5aPMrFbyV3aHXUS3BAOb1Snl+Q52GuvGsPAJxl9LvzM/gSBMutTrDCN8E8yIRdFOEZjF6FQ01sw+02PDT3KPmYzhm0=  ;
X-YMail-OSG: RDTVKTsVM1nXEMNNNXf_r4odvr._NxL9fg0nF6xttNd8MCQ._7aPkfK.6MlVxWi9X.XlMmKk9g--
Date: Thu, 19 Apr 2007 08:20:59 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Message-ID: <20070419062059.GA3974@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070413091422.GA15426@zmei.tnic> <20070414091341.7665d8b0.randy.dunlap@oracle.com> <20070415071050.GA4002@gollum.tnic> <20070417104907.GA6155@gollum.tnic> <20070418090320.3786edd6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070418090320.3786edd6.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>
> > I'm pretty sure the reason you cannot reproduce this warning is the line 
> > 
> > <xsl:param name="refentry.version.suppress">1</xsl:param>
> > 
> > which can be found in param.xsl, it being a part of the docbook-xsl
> > distribution. The parameter's name is self-explanatory and a '1' suppresses
> > the version generation. I was able to get this error because in the
> > debian docbook-xsl package this param value is set to 0 by default.
> 
> Hm, I don't seem to have that file installed (except in
> /usr/share/xml/docbook/stylesheet/...).  Where would it normally
> be installed?

/usr/share/xml/docbook/stylesheet/nwalsh/manpages/param.xsl here


> > This means, some users will get this warning and some will not, depending on the
> > setting in the param.xsl file. What is the way to go here wrt to a solution
> > dealing with all cases:
> > 
> > 1. patch the kernel-doc?
> > 2. issue an info so that the user can suppress the annoying warning by
> > themselves?
> > 3. ...?
> 
> 
> Are other people seeing these warning messages ??
Hm, is anyone building the manpages target at all?

> If so, I think that we should patch the kernel-doc.  I don't think
> that many people would read info about how to avoid the warnings.

-- 
Regards/Gruﬂ,
    Boris.
