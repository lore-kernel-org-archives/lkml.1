Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYEDNrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYEDNrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 09:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbYEDNr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 09:47:28 -0400
Received: from OSB1387.piap.pl ([195.187.100.11]:35028 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbYEDNr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 09:47:27 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Paul Mackerras <paulus@samba.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org>
	<18457.219.995207.136771@cargo.ozlabs.ibm.com>
	<alpine.LFD.1.10.0804302034180.5994@woody.linux-foundation.org>
	<48194464.2000406@garzik.org>
	<alpine.LFD.1.10.0804302142570.5994@woody.linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 04 May 2008 15:47:25 +0200
In-Reply-To: <alpine.LFD.1.10.0804302142570.5994@woody.linux-foundation.org> (Linus Torvalds's message of "Wed\, 30 Apr 2008 21\:46\:52 -0700 \(PDT\)")
Message-ID: <m3skwyxjte.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Personally I think the current process works reasonably well, though
as we should always try to improve it further...

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 1 May 2008, Jeff Garzik wrote:
>> - opens all the debates about running parallel branches, such as, would it be
>> better to /branch/ for 2.6.X-rc, and then keep going full steam on
>> the trunk?

I think you could branch at ~ rc3 (strictly critical fixes only from
this point). This way 'next' wouldn't be low-maintenance but the
release branch would be.

I.e., the merge window would open at ~ rc3. At 'final', the merge window
would probably be already closed :-)

Something like:
- 2.6.26-rc3: 2.6.27 merge window opens, 2.6.26 - fixes only
- 1 week later: no core changes for 2.6.27 except fixes (drivers only?)

2.6.26* would receive backports from 2.6.27 (cherry-picking? applying
on 2.6.26 and merging?).

The "no open regressions" rule would make sense certainly - unless in
a specific case agreed otherwise.

Perhaps if needed you could let other people do the final release
("stable" extension) and concentrate on the trunk.

> If I'd have both a 'next' branch _and_ a full 2-week merge window, there's 
> no upside.

Shorter cycle is the big upside.

Perhaps we could start branching later at first - say at 2.6.26-rc5,
and see how does it work.
-- 
Krzysztof Halasa
