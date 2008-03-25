Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYCYNq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYCYNq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYCYNqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:46:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45888 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbYCYNqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:46:17 -0400
Date: Tue, 25 Mar 2008 14:45:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: David Miller <davem@davemloft.net>, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
Message-ID: <20080325134556.GA10424@elte.hu>
References: <20080323085210.GE10722@ZenIV.linux.org.uk> <20080323.032013.79276201.davem@davemloft.net> <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325133810.GA10044@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> you picked an borderline case without showing the full effects of your 
> choice of style - but still even in this example you are wrong i 
> believe. [...]

and let me give an example with the your very own code that you wrote 
and maintain, drivers/mtd/devices/block2mtd.c:

                                    errors   lines of code   errors/KLOC
drivers/mtd/devices/block2mtd.c         10             490          20.4

that's pretty OK code, but not perfect, the 10 errors are:

 ERROR: do not use C99 // comments
 ERROR: need spaces around that '=' (ctx:VxV)
 ERROR: need spaces around that '<' (ctx:VxV)
 ERROR: do not use C99 // comments
 ERROR: do not use C99 // comments
 ERROR: do not use C99 // comments
 ERROR: do not use C99 // comments
 ERROR: do not use C99 // comments
 ERROR: do not use C99 // comments
 ERROR: do not initialise statics to 0 or NULL

so just because you disagreed with those 2 errors that relate to '=' and 
'<' (and where accoding to CodingStyle checkpatch.pl is correct), you 
disregarded the other 8 very valid complaints that checkpatch.pl had. 
(the final one even negatively affects the size of the kernel)

and this is the experience i made in general: the checkpatch.pl benefits 
far outweigh the costs, even if you disagree with a particular rule of 
checkpatch.pl. When you came to Linux you already had to change your 
coding style quite radically, correct?

	Ingo
