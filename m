Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbXEYW2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbXEYW2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbXEYW1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:27:54 -0400
Received: from terminus.zytor.com ([192.83.249.54]:58292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbXEYW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:27:53 -0400
Message-ID: <4657626B.7010204@zytor.com>
Date: Fri, 25 May 2007 15:25:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn"
 standard.
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain>	 <46572DAF.1000108@zytor.com>	 <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain>	 <46573B23.1090700@zytor.com>	 <Pine.LNX.4.64.0705251705510.14578@localhost.localdomain>	 <4657589F.7050509@zytor.com> <a781481a0705251516l5de0e95ayae45f7a65e25c8cf@mail.gmail.com>
In-Reply-To: <a781481a0705251516l5de0e95ayae45f7a65e25c8cf@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> 
> But __attribute__((noreturn)) is simply a _function attribute_. Of course,
> it is legal / valid only for functions with return-type void, so it does
> make
> sense to combine both void and __attribute__((noreturn)) in the same
> macro like you say. But that's not syntactically necessary. In fact,
> grepping through the sources, a lot of people do prefer to place the
> attribute _after_ the function declarator.
> 
> Anyway, I'm fine either way.
> 

Sorry to say, but weren't you the person who didn't recognize !! as the
idiomatic booleanizing operator?

I think you need to learn that everything that the compiler accepts
isn't necessarily idiomatic, readable code.  Consider
__attribute__((noreturn)); it's a nonstandard feature implemented using
a generic gcc mechanism -- thus what the compiler will accept is quite
flexible, because it's a generic building block.  It doesn't mean it's a
good idea.

The reason it's often written at the end of the expression mostly has to
do with bugs in some very early versions of gcc.

	-hpa
