Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYH3G6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYH3G6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 02:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYH3G6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 02:58:40 -0400
Received: from web82102.mail.mud.yahoo.com ([209.191.84.215]:27146 "HELO
	web82102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751061AbYH3G6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 02:58:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=OrMQz65iNnznvfFYcq3zT0PlnREGl/SoUj+6sYtcMPgU1g+KrzLMHsM97Etywv8zaMMdhHsPzNeQhItIrutG87E7Wx1GfIOqwF+12Z3ORaitWygTC5EW+XNzsh2R4tBEOsBqh7e4Bd9EpwX+YMobQ+pmYZF1qSHKLhQ0ytyCTxY=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218.2
Date: Fri, 29 Aug 2008 23:58:39 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <734251.73444.qm@web82102.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Sorry if I am interfering... just wanted to inject this data, in case
> > it's meaningful!
> 
> Yeah, nothing has changed yet for your case. What should change your case 
> is the thing Yinghai is working on with the "late add of e820 data to the 
> resource tree".

OK.


> His earlier version already worked for you, didn't it? We're really now 
> just finalizing details (in fact, "insert_resource_expand_to_fit()" is 
> just a helper function for a detail that may not even matter all that 
> much).

Yes, it worked fine!  :D

BTW, there was an individual who reported a regression back in May on the
very same commit.  I was not able to get him to participate in the process
of tracking this down, but he did (suddenly) write a post on his blog a
couple of days ago that he had success using some unspecified git tree HEAD.

I believe that was probably the patch that you have reverted, so once I
know that a new candidate is in place I will let him know on his blog and
see if I can talk him into trying it.  This has been a month-long quest
for me -- beginning on Aug. 4 -- and I can understand why he gave up in
May without resolving the issue.  It's too bad for all of us that he didn't
pursue it then, huh?


Thanks,
Dave W.
