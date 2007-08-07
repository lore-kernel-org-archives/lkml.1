Return-Path: <linux-kernel-owner+w=401wt.eu-S938075AbXHGWGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938075AbXHGWGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965459AbXHGVmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:42:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57211 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966748AbXHGVmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:42:02 -0400
Date: Tue, 7 Aug 2007 23:40:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: ibm-acpi-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: refcounting problems with ibm_acpi but acpi=off
Message-ID: <20070807214058.GA4413@elf.ucw.cz>
References: <20070807104500.GA1684@elf.ucw.cz> <20070807142607.GA7414@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807142607.GA7414@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > --- a/drivers/acpi/ibm_acpi.c
> > +++ b/drivers/acpi/ibm_acpi.c
> > @@ -2695,6 +2695,9 @@ static void acpi_ibm_exit(void)
> >  {
> >  	int i;
> >  
> > +	if (acpi_disabled)
> > +		return;
> > +
> >  	for (i = ARRAY_SIZE(ibms) - 1; i >= 0; i--)
> >  		ibm_exit(&ibms[i]);
> >  
> > 
> 
> Indeed it is required, my bad.
> 
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> 
> Do you want me to forward a git patch to Len brown?

Yes, please. Hmm, seems like at least asus_acpi is affected by same problem.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
