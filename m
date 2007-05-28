Return-Path: <linux-kernel-owner+w=401wt.eu-S1763083AbXE1SiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763083AbXE1SiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 14:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbXE1Sh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 14:37:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46308 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbXE1Sh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 14:37:58 -0400
Date: Mon, 28 May 2007 20:38:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: fix section mismatch warnings
Message-ID: <20070528183858.GB30821@uranus.ravnborg.org>
References: <20070528163253.GA29174@uranus.ravnborg.org> <20070528164427.GB29174@uranus.ravnborg.org> <20070528170936.GC5737@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528170936.GC5737@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >  
> > -static int __init neponset_init(void)
> > +static int __devinit neponset_init(void)
> >  {
> >  	platform_driver_register(&neponset_device_driver);
> >  
> 
> How can this hunk be correct?  neponset_init() is only called from
> subsys_initcall() - it's not something we want to keep at init time.
> I'm afraid I suspect faulty section analysis.
As covered in other mail - it is not.
The __devinit stuff should all be redone by a knowledgeable person.

	Sam
