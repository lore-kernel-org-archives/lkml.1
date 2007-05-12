Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbXELHCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbXELHCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 03:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXELHCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 03:02:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:25919 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbXELHCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 03:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MQHowaePxwoNoOuqf8+PWn+G6Fgrp5mwQaXd8031u9bbKxsVKdKt9/tchPEwSQJKYbupgiBe4+ClFIrOvwPyfw6ZfloV/a8O6MS0VOhxsljnUCGzhPu5mWV1JHNkLLaCei5Kpeh1RzScjO1MoEOOhHJCWtBdKBHgxnZdbFvDRmQ=
Message-ID: <a781481a0705120002xb604e7al629ceb1c27109451@mail.gmail.com>
Date: Sat, 12 May 2007 12:32:15 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] "volatile considered harmful", take 3
Cc: "Jonathan Corbet" <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Johannes Stezenbach" <js@linuxtv.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Heikki Orsila" <shdl@zakalwe.fi>,
       "jimmy bahuleyan" <knight.camelot@gmail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <46455CD9.7010205@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12700.1178905000@lwn.net>
	 <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>
	 <464551D5.2050709@zytor.com>
	 <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com>
	 <46455CD9.7010205@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Satyam Sharma wrote:
> >
> > Because volatile is ill-defined? Or actually, *undefined* (well,
> > implementation-defined is as good as that)? It's *so* _vague_,
> > one doesn't _feel_ like using it at all!
> >
>
> Sorry, that's just utter crap.  Linux isn't written in some mythical C
> which only exists in standard document, it is written in a particular
> subset of GNU C.  "volatile" is well enough defined in that context, it
> is just frequently misused.

Of course, volatile _is_ defined (well, _anything_ that is implemented
_is_ defined, after all) in the context of GNU C, and if you're saying
that the kernel (and all its subsystems) is and should _continue_ to
be (the purpose of this document) written within that context, then
that's your opinion and I would not disagree with you. If you do
prefer to continue using that dialect, then I wouldn't stop you either.

Personally, I'd prefer writing in a slightly more portable / larger
context (using well-defined and understood APIs), thank you, and
hope you'd allow me to do so myself.

Coming back to the document, we do need to document / find
consensus on the "preferred" way to do similar business in the
kernel, and my opinion as far as that is concerned is to shun
volatile wherever possible (which includes the case originally
discussed above).

Satyam
