Return-Path: <linux-kernel-owner+w=401wt.eu-S1762458AbXGFOgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762458AbXGFOgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbXGFOgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:36:07 -0400
Received: from serv07.divms.uiowa.edu ([128.255.44.97]:36601 "EHLO
	serv07.divms.uiowa.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbXGFOgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:36:06 -0400
X-Greylist: delayed 1811 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2007 10:36:06 EDT
In-Reply-To: <20070705143419.f214f5b2.akpm@linux-foundation.org>
References: <200707051251.52891.vda.linux@googlemail.com> <20070705143419.f214f5b2.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6F17353B-D428-462B-B318-2FDEC11E8D66@cs.uiowa.edu>
Cc: Denis Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: "Douglas W. Jones" <jones@cs.uiowa.edu>
Subject: Re: [PATCH 2/2] vsprintf.c: optimizing, part 2: base 10 conversion speedup, v2
Date: Fri, 6 Jul 2007 09:05:29 -0500
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 5, 2007, at 4:34 PM, Andrew Morton wrote:

> On Thu, 5 Jul 2007 12:51:52 +0200
> Denis Vlasenko <vda.linux@googlemail.com> wrote:
>
>> Using code from
>>
>> http://www.cs.uiowa.edu/~jones/bcd/decimal.html
>> (with permission from the author, Douglas W. Jones)
>
> Neither of your patches had signed-off-by:s.  Would prefer that  
> they were
> included please, given that we're adding stuff from someone's website.

The material on my website was somewhere between pseudocode and
code.  The web site is tutorial in nature, and what Vlasenko did
is follow my tutorial and adapt a working chunk of code from the
many code snippets in the tutorial.

If a signoff from me is required, someone will need to tell me how,
since I have no experience with the protocols for Linux code
development.  I am entirely content with the current form of credit
given to me in the code (a comment with a pointer to my web site).

Frankly, I remain a bit surprise that my work has significant payoff
on a Pentium.  I was motivated by the problems of doing fast binary
to ASCII decimal conversion on a brain-dead little microcontroller
with an 8-bit ALU.

		Doug Jones
		jones@cs.uiowa.edu
