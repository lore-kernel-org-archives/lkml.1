Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbXELH23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbXELH23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 03:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbXELH2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 03:28:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:44431 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbXELH2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 03:28:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X0s5GVdC2bwewD9QhTHsnk80U9yFt7VZgfAOS3SnlLnbeNTpXBwcBeD8udGdNZSk5aH2MxsHF/suhfThpqHVfnT2clejLuRO58qX4r70Q95ysh59GOTCL9Zd5Qg5HJIyat7DmZy21Qo1w2IzdnOxzoJujldFQFICTa9eJ+nWGX8=
Message-ID: <a781481a0705120028m744ad579l5fb0950e6ffcfac4@mail.gmail.com>
Date: Sat, 12 May 2007 12:58:19 +0530
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
In-Reply-To: <4645691C.5090408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12700.1178905000@lwn.net>
	 <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>
	 <464551D5.2050709@zytor.com>
	 <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com>
	 <46455CD9.7010205@zytor.com>
	 <a781481a0705120002xb604e7al629ceb1c27109451@mail.gmail.com>
	 <4645691C.5090408@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Satyam Sharma wrote:
> >>
> >> Sorry, that's just utter crap.  Linux isn't written in some mythical C
> >> which only exists in standard document, it is written in a particular
> >> subset of GNU C.  "volatile" is well enough defined in that context, it
> >> is just frequently misused.
> >
> > Of course, volatile _is_ defined (well, _anything_ that is implemented
> > _is_ defined, after all) in the context of GNU C, and if you're saying
> > that the kernel (and all its subsystems) is and should _continue_ to
> > be (the purpose of this document) written within that context, then
> > that's your opinion and I would not disagree with you. If you do
> > prefer to continue using that dialect, then I wouldn't stop you either.
> >
>
> This isn't just an opinion, this is the language the Linux kernel is
> written in today, and has been for the duration of its 16-year

I said "and should _continue_ to be (the purpose of this document)
written within that context, then that's your opinion". That "is" before
the "and should ..." was not meant to be combined with "your
opinion".

> existence.  It contains *many* constructs that are not defined in, for
> example, C99, and it would in fact be impossible to write the Linux
> kernel using only C99-compliant constructs.

And that is not what I attempt to do (or even suggest) either. Which is
why I do *not* disagree with the jiffies clause -- it exists in that
document merely to _inform_ readers about _current_ behaviour /
dialect of the kernel and not to influence code written in the future.
The problem with the last clause is that it explicitly influences
*future* code (by coming in as a "rare situation where volatile
makes sense in the kernel").

> > Personally, I'd prefer writing in a slightly more portable / larger
> > context (using well-defined and understood APIs), thank you, and
> > hope you'd allow me to do so myself.
>
> There is no such "slightly more portable/larger context/well-defined and
> understood" context in existence.  If you think so, you're deluding
> yourself.

If you remember my original mail was in the "_why_ use volatile" tone,
which means to _dissuade_ future spurious additions of volatile to the
kernel. Now this _is_ a matter of opinion: I personally prefer as much
(if not all) future code to be dialect-independent, you might not.

Satyam
