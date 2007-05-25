Return-Path: <linux-kernel-owner+w=401wt.eu-S1752464AbXEYWfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbXEYWfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXEYWfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:35:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:30378 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXEYWfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NCJ//FJtD1rZsOj5vYNXsd8CDOi6mXYbBbZfEgsA6O7jqm9bYfeNeo4XwsjZbiyMTXfDiZi9GSIifmAV3VhU97bC63P2eNHJZJpWntm15nMgjKzQwIK4D32+3Vsp+oiPh7ViMBHb7O2WMJ8Xpj2in0KbwZeQIZmErPWZD7JMQTc=
Message-ID: <a781481a0705251535g27bd38a5s496cc7b44f2d45d5@mail.gmail.com>
Date: Sat, 26 May 2007 04:05:46 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn" standard.
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ralf Baechle" <ralf@linux-mips.org>
In-Reply-To: <4657626B.7010204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain>
	 <46572DAF.1000108@zytor.com>
	 <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain>
	 <46573B23.1090700@zytor.com>
	 <Pine.LNX.4.64.0705251705510.14578@localhost.localdomain>
	 <4657589F.7050509@zytor.com>
	 <a781481a0705251516l5de0e95ayae45f7a65e25c8cf@mail.gmail.com>
	 <4657626B.7010204@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Satyam Sharma wrote:
> >
> > But __attribute__((noreturn)) is simply a _function attribute_. Of course,
> > it is legal / valid only for functions with return-type void, so it does
> > make
> > sense to combine both void and __attribute__((noreturn)) in the same
> > macro like you say. But that's not syntactically necessary. In fact,
> > grepping through the sources, a lot of people do prefer to place the
> > attribute _after_ the function declarator.
> >
> > Anyway, I'm fine either way.
> >
>
> Sorry to say, but weren't you the person who didn't recognize !! as the
> idiomatic booleanizing operator?

Yes, of course, please prove a link / connection between that and this?

> I think you need to learn that everything that the compiler accepts
> isn't necessarily idiomatic, readable code.  Consider
> __attribute__((noreturn)); it's a nonstandard feature implemented using
> a generic gcc mechanism -- thus what the compiler will accept is quite
> flexible, because it's a generic building block.  It doesn't mean it's a
> good idea.
>
> The reason it's often written at the end of the expression mostly has to
> do with bugs in some very early versions of gcc.

That might be, but I was only saying that there is no syntactical
*compulsion* to combine the attribute with the return type. As for what's
readable, it is subjective. And as for what's common / standard / idiomatic
in the kernel code as of today, nothing beats a grep. Anyway, as I said
previously, I'm fine with either way.

Satyam
