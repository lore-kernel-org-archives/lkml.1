Return-Path: <linux-kernel-owner+w=401wt.eu-S1751118AbXBRNoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbXBRNoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 08:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXBRNoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 08:44:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:8707 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbXBRNn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 08:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CdOP6pcB/QIomqiKMheKE3tz1v3ltJPPwgkHzUPzSZ9VJQpHPHGotkJ9JVkBQqgvcY2km9kFH5FadbQZl9RXEkkjVda4K1+ojpKj79DnFnViwGnvby3sajen7ZAJumHm+w4+BL0sCw4KAoYF3ZiFIySuElqcYmazTu8agYC9DqM=
From: Maxim <maximlevitsky@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Subject:  [PATCH 2.6.20 004/005] dmfe: Add support for suspend/resume
Date: Sun, 18 Feb 2007 15:43:53 +0200
User-Agent: KMail/1.9.6
Cc: netdev@kernel.org, linux-kernel@vger.kernel.org
References: <200702152253.53680.maximlevitsky@gmail.com> <200702180029.03651.maximlevitsky@gmail.com> <20070217225215.GE14222@elf.ucw.cz>
In-Reply-To: <20070217225215.GE14222@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181543.53296.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 February 2007 00:52:15 Pavel Machek wrote:
> Hi!
> > 
> > Hello ,  I am sorry that I missed some parts of coding style. I need to reread it :-)
> > 
> > There is a updated patch :
> 
> It looks better.
> 
> > +	/* Disable Interrupt */
> > +	outl (0, dev->base_addr + DCR7);
> > +	outl (inl(dev->base_addr + DCR5), dev->base_addr + DCR5);
> 
> I'd kill space after outl...
> 
> > +	/* Free RX buffers */
> > +	dmfe_free_rxbuffer(db);
> > +
> > +	/* Power down device*/
> 
> and add space before */.
> 
> Congratulation, you passed coding-style-police-check ;-).
> 									Pavel
> 

Hello,
	Thanks for reply, I just want to ask one question:

	Those patches are now merged in -mm, and I noticed that Andrew Morton after applying them did fix my bad coding style and check for CONFIG_PM=n that I didn't include

	Now should I resend two last patches or not ?


Regards, Maxim Levitsky


PS:  Actualy I have planned to send those patches a little bit later , and do more checks like the coding style stuff, mailer problems, etc... 
but I noticed that 2.6.20 breaks link detection on my card,
and I even saw report here on LKML about that, so I decided to send them now

Of cource I did check them for code correctness , and I actualy used them for about a month.
I tried to do as little as possible changes, and verify each line.

