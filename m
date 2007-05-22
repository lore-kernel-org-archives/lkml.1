Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbXEVVfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbXEVVfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758223AbXEVVe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:34:57 -0400
Received: from ns.firmix.at ([62.141.48.66]:60101 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757993AbXEVVe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:34:56 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 17:34:56 EDT
Subject: Re: [RFC] LZO1X de/compression support
From: Bernd Petrovitsch <bernd@firmix.at>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: Andrey Panin <pazke@donpac.ru>, linux-kernel@vger.kernel.org,
       Richard Purdie <richard@openedhand.com>
In-Reply-To: <4cefeab80705220208w2200b2f1x1d7a8c7e0c01dfb9@mail.gmail.com>
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
	 <20070518111107.GA27003@pazke.donpac.ru>
	 <4cefeab80705220208w2200b2f1x1d7a8c7e0c01dfb9@mail.gmail.com>
Content-Type: text/plain
Organization: http://www.firmix.at/
Date: Tue, 22 May 2007 23:24:42 +0200
Message-Id: <1179869082.3649.6.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.423 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.423 required=5
X-Spam-Score: -2.423 () AWL,BAYES_00,FORGED_RCVD_HELO
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 14:38 +0530, Nitin Gupta wrote:
[...]
> On 5/18/07, Andrey Panin <pazke@donpac.ru> wrote:
> > On 138, 05 18, 2007 at 03:28:31PM +0530, Nitin Gupta wrote:
> > > +     register const unsigned char *ip;
> >
> > register keyword is meaningless for today's compiler.
> 
> But can we assume that gcc is being used? What if we use compiler for

Yes.
If another compiler wants to compile the kernel, it must have
implemented various widely used gcc extensions.

> which it does matter (can't give example for this...)?

The "register" keyword is and was always from start *at most* a hint to
the C compiler to use a register for that variable (similar to "inline"
BTW).
So every C compiler is allowed to simply ignore the "register" for any
reason - be it "not implemented" or "the compiler knows better".
Trivial reason: Think of a function with 100 register variables.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

