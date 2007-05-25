Return-Path: <linux-kernel-owner+w=401wt.eu-S1765650AbXEYVoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765650AbXEYVoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759135AbXEYVoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:44:07 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932AbXEYVoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:44:04 -0400
Message-ID: <4657589F.7050509@zytor.com>
Date: Fri, 25 May 2007 14:43:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn"
 standard.
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain> <46572DAF.1000108@zytor.com> <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain> <46573B23.1090700@zytor.com> <Pine.LNX.4.64.0705251705510.14578@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705251705510.14578@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>> ... and declare functions as:
>>
>> __noreturn f();
>>
>> ... which is the syntactially sane way of doing it.
> 
> that may be, but keep in mind that gcc allows attributes to *follow*
> the parameter list as well, and some people might prefer to do the
> following:
> 
>   f() __noreturn;
> 
> that would fail badly if you defined __noreturn as you suggest.

That's equally moronic that saying that "some people might prefer to
write 'f() void;'", which is what it's *EXACTLY* equivalent to.  Yes,
they might "prefer" it, but it's syntactically invalid and the compiler
won't accept it.  As it shouldn't.

__noreturn here takes the syntactic place of the return type, because
that's what it IS.

	-hpa
