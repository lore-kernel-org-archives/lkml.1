Return-Path: <linux-kernel-owner+w=401wt.eu-S1030405AbXDJWWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405AbXDJWWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030403AbXDJWWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:22:21 -0400
Received: from ms.trustica.cz ([82.208.32.68]:45193 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030405AbXDJWWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:22:19 -0400
Message-ID: <461C0E0E.5090008@assembler.cz>
Date: Wed, 11 Apr 2007 00:22:06 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: LM Sensors <lm-sensors@lm-sensors.org>
CC: David Hubbard <david.c.hubbard@gmail.com>,
       Hans de Goede <j.w.r.degoede@hhs.nl>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] Hardware monitoring subsystem maintainer position
 is open
References: <20070410150227.1bac05b5@hyperion.delvare>	<461BB006.9020308@hhs.nl> <4dfa50520704100846s7c031ab0i9da94a9e993cbbfc@mail.gmail.com>
In-Reply-To: <4dfa50520704100846s7c031ab0i9da94a9e993cbbfc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

First I would like to thank Jean for his great work even if could be seen as 
"slow". He did the perfect job, allowing only just perfect code to enter the trees.

> I haven't seen anything from Rudolf Marek, but he is definitely
> qualified if he wants to step up. I'm personally hoping Jean changes
> his mind.

Well I'm afraid Jean thought about this twice and I think his decision cannot be 
changed easily. Personally I think that change of one person to another won't 
change much. Problem we are facing is long delay between the post of the driver 
to driver merge.

Review of one complex driver takes hours and hours. If the fixes could be split 
into critical and non-critical parts driver could be accepted earlier and marked 
as EXPERIMENTAL in very new (for hwmon ;) meaning of the word. I mean Jean did 
great job and spotted all troubles during the review, so there were nearly none 
of bug fixes for already merged drivers.

Maybe we could try following:

1) person post the driver
2) quick review could be done critical fixes only, driver goes to -mm
3) review that goes deeper - check for interface conformity and all the stuff 
which could break - fixes for non-critical stuff
4) after this driver goes to Linus tree at the very beginning for the merge 
cycle marked as EXPERIMENTAL
5) if the person agrees to be in MAINTAINER final review may be done and 
EXPERIMENTAL could be removed. (This is step which might involve all steps to 
make the driver really perfect ;)

Well this is just an idea. Neither it does solve the maintainer problem, nor it 
is perfect solution.

As for the proposal of David. I joined the list in 2004 with my very own driver 
and learned a lot from Jean and others and on my own ;) During last year??? I 
was doing some kind of "review preprocessor" to help Jean with that. I still 
have feeling Jean is simply better. Second reason why I hesitating to say "I 
will take it" is time. This would cost a lot of time, but unfortunately my free 
time is very tight. I'm doing PhD and working for a embedded stuff company 
(SYSGO). Moreover I would like to meet some nice girl for a life, which is quite 
difficult and also quite time consumptive ;).

Personally better would be go with Jean and some kind of scheme noted above, 
which would solve our "takes too long problem" and preserve the high quality of 
drivers. This would mean some co-maintainers to Jean, rather than to live 
without Jean at all.

Thanks,
Rudolf

