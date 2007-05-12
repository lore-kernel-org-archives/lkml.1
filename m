Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbXELHOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbXELHOt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 03:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbXELHOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 03:14:42 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbXELHOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 03:14:41 -0400
Message-ID: <4645691C.5090408@zytor.com>
Date: Sat, 12 May 2007 00:13:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Jonathan Corbet <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       jimmy bahuleyan <knight.camelot@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] "volatile considered harmful", take 3
References: <12700.1178905000@lwn.net>	 <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>	 <464551D5.2050709@zytor.com>	 <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com>	 <46455CD9.7010205@zytor.com> <a781481a0705120002xb604e7al629ceb1c27109451@mail.gmail.com>
In-Reply-To: <a781481a0705120002xb604e7al629ceb1c27109451@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>>
>> Sorry, that's just utter crap.  Linux isn't written in some mythical C
>> which only exists in standard document, it is written in a particular
>> subset of GNU C.  "volatile" is well enough defined in that context, it
>> is just frequently misused.
> 
> Of course, volatile _is_ defined (well, _anything_ that is implemented
> _is_ defined, after all) in the context of GNU C, and if you're saying
> that the kernel (and all its subsystems) is and should _continue_ to
> be (the purpose of this document) written within that context, then
> that's your opinion and I would not disagree with you. If you do
> prefer to continue using that dialect, then I wouldn't stop you either.
> 

This isn't just an opinion, this is the language the Linux kernel is
written in today, and has been for the duration of its 16-year
existence.  It contains *many* constructs that are not defined in, for
example, C99, and it would in fact be impossible to write the Linux
kernel using only C99-compliant constructs.

> Personally, I'd prefer writing in a slightly more portable / larger
> context (using well-defined and understood APIs), thank you, and
> hope you'd allow me to do so myself.

There is no such "slightly more portable/larger context/well-defined and
understood" context in existence.  If you think so, you're deluding
yourself.

	-hpa
