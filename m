Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbZCYRDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbZCYRDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZCYRDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:03:34 -0400
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:35848 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752074AbZCYRDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:03:33 -0400
X-Yahoo-Newman-Id: 367750.84592.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GiccPiQ+ZErJGLffH46Ji+9YyMqACEuiMptY+rZ0SGjsIC1VsWJMOMuZOtCj58ALJVmkpnnvnyTCYm47FgYVUnWsiwVjWJFW0bkXzxRqr9/LcqGQbrQ/bAVfO2t2722cT2DuWDJf10zLCtDfpLuOjEIjnt7r3gTXo10/7vxjGLc=  ;
X-YMail-OSG: 7eaAltsVM1llsrQGh4lEajIaQMcNpwOKXfXfWLBZHL4jtB2z.A75m9QZZjD7upBY_R4rNZs85Zv72mgnsW4T4mL204Av.4nXRSQU1xQC5Eb0vajiaPf1S1TVceEpes3jc.MZRvYVOsf0iqQnyt43T2jQ5oKVX6ikv1saX_VHITkLtZY13s_SCQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH] regulator: twl4030 VAUX3 supports 3.0V
Date: Wed, 25 Mar 2009 10:03:29 -0700
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@sirena.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-omap Mailing List" <linux-omap@vger.kernel.org>
References: <49B11EB0.30809@nokia.com> <1237290190.6781.313.camel@vega.slimlogic.co.uk> <49C9EB17.2020408@nokia.com>
In-Reply-To: <49C9EB17.2020408@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903251003.29340.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009, Adrian Hunter wrote:
> >> http://community.ti.com/forums/p/3777/14574.aspx
> >>
> >> So how do we do it?
> > 
> > I'd prefer seeing the reply from Ghandar to David's last question before
> > accepting this patch again. It's still not 100% clear from TI, things
> > seem a little bit muddled as to whether 3V will be guaranteed to work on
> > *all* shipped devices.
> 
> Ghandar has responded.  What would you like to do?

Update the patch to include a comment (by the table def)
that TI says they're revising the twl5030/tps659x0 specs
to support that 3.0V setting, then merge it.

(Umm, though I'd be sure to find out specifically which
selectors they're supporting that way, first...)

I don't think they'll be revising specs on chips they've
shipped already ... but this isn't likely to matter on
those older systems, anyway; example, the 3430 SDP uses
VAUX3, but at the always-supported 2.8V setting.



