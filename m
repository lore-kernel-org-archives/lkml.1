Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbZBXCEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbZBXCEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 21:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbZBXCDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 21:03:54 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:48026 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755294AbZBXCDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 21:03:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nRL0f4FHZN1/U51KXq8jbJ1GV/+AXLQ55WB//Hq57DPtzRTwyrBeikY9ej1C5w+D193bjPV8M1ZD+IE4o1NbKqKtbydvKSxq62pSsx56ALG7vyZE2UpR3gLikoqivGSZD9FZAhFtCKlIimJkepjipVVeDxCkYeECxDtBnzAfL+Q=  ;
X-YMail-OSG: bes5WQUVM1k04.8hbEf1UzedgGXO0EfDQ_uOtJmajSJMBN62gxRjFqrsAcHkI2w4tkqDBhWjK13whb9svE2Bn8b19XUmcy.ehQSU.ed2SJ688ndQQguzkWCh74DizRbVniU162DGgWy9OkKLbmfn00IuSSBVgvIiqWApOAC81ZSfreYBFef6bPVvKqnu
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
Date: Mon, 23 Feb 2009 18:03:49 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902231443.16334.david-b@pacbell.net> <20090224005536.GC3601@sirena.org.uk>
In-Reply-To: <20090224005536.GC3601@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231803.50059.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Mark Brown wrote:
> The change to add voltage range constraints if none were supplied is a
> noticable policy change from the existing framework standard - it allows
> machines to enable voltage changes without specifying what the valid
> values are. 

"Whatever the hardware handles" *is* a specification.

And there's no more assurance it's right than any
other specification would be ... except that, as a
rule, hardware designers like to avoid assemblies
subject to trivial misconfiguration mistakes (like
firing up a 2.5V-max rail at 5V).


> I'm not convinced that this is a good idea in the first 
> place and it will result in the opposite behaviour to the current core
> code (which should end up erroring out in constraint checking at runtime).

Well, if you really dislike it so much, that can
easily be removed.  Got any comments on the
framework patch I sent?  I'll take that as the
first one, even though it's a different thread.

- Dave



