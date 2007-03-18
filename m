Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbXCRIUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbXCRIUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbXCRIUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:20:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:65143 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbXCRIUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=Wf10W3dIxWziQGq0KU4pFIjXTaCDQTrVaWsWCH7r3zi0UaWUsMrQEWcMrN87gxzTPR973Av7yRnZBuETPUf6jaolZp6Fd7a+cuwDGKTGSEJ3Un9zxna5iGCjLt+5RzoVAah9BMGUEbSjBe9NdKc8g/FRhDnj9awYZvaP01ezkWw=
Message-ID: <45FCF631.9020200@gmail.com>
Date: Sun, 18 Mar 2007 13:50:01 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Radoslaw Szkodzinski <astralstorm@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>
Subject: Re: [ck] Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com>	 <200703172048.46267.kernel@kolivas.org>	 <1174125534.7734.2.camel@Homer.simpson.net>	 <200703172355.30989.a1426z@gawab.com>	 <1174198651.8199.44.camel@Homer.simpson.net>	 <1174200463.10498.23.camel@localhost>	 <1174201726.8732.6.camel@Homer.simpson.net>	 <f44c5fdf0703180022n44b2ca61o62602e54aaab3334@mail.gmail.com> <1174203482.8855.8.camel@Homer.simpson.net>
In-Reply-To: <1174203482.8855.8.camel@Homer.simpson.net>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sun, 2007-03-18 at 08:22 +0100, Radoslaw Szkodzinski wrote:
> 
>> I'd recon KDE regresses because of kioslaves waiting on a pipe
>> (communication with the app they're doing IO for) and then expiring.
>> That's why splitting IO from an app isn't exactly smart. It should at
>> least be ran in an another thread.
> 
> Hm.  Sounds rather a lot like the...
> X sucks, fix X and RSDL will rock your world.  RSDL is perfect.
> ...that I've been getting.
> 
> 	-Mike

maybe if it is possible to classify program behaviors that cause RSDL to
do bad (relatively) or the mainline scheduler to jitter, we could try
modifying the existing heuristics to get a better default scheduler.

of course, it wouldn't be able to cater to all the workloads and would
meet everybody's definition of optimal. but getting close to optimal in
most cases should be a good enough goal for linux's default sched!

i've been following this thread, and there's been many instances of
'RSDL is gr8' and 'RSDL regresses'.

maybe RSDL isn't the answer. maybe the current mainline sched isn't
either. but RSDL definitely has done *something* right.

What i think is needed is 'why this works here' and 'how to get this
behavior to work with some other possibly conflicting but important
workloads'.

(just my 2c :-)


-jb
-- 
I am professionally trained in computer science, which is to say
(in all seriousness) that I am extremely poorly educated.
                -- Joseph Weizenbaum
