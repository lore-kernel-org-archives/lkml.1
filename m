Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbYEDPKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbYEDPKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbYEDPKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:10:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:17822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYEDPKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CJNSZ1myWKcx3FzoPe3BZBNZCydolho2qofDd1AVeEzfIJ4PAUosdFxdgdKGMcQHzegAPUgdqh6JvyRrXextRTonDmAiBzWGSAW1lQiqZKBU4eRj2wJGHa900YOo7WBwerNAGuAgAg0c9HARa49cCoVUtyznw9BjTOqYqRoXsRA=
Message-ID: <481DD0C5.4060005@gmail.com>
Date: Sun, 04 May 2008 17:05:41 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Paul Mackerras <paulus@samba.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net>	<200804302136.58005.rjw@sisk.pl>	<alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org>	<18457.219.995207.136771@cargo.ozlabs.ibm.com>	<alpine.LFD.1.10.0804302034180.5994@woody.linux-foundation.org>	<48194464.2000406@garzik.org>	<alpine.LFD.1.10.0804302142570.5994@woody.linux-foundation.org> <m3skwyxjte.fsf@maximus.localdomain>
In-Reply-To: <m3skwyxjte.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa pisze:
> Personally I think the current process works reasonably well, though
> as we should always try to improve it further...
> 
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
>> On Thu, 1 May 2008, Jeff Garzik wrote:
>>> - opens all the debates about running parallel branches, such as, would it be
>>> better to /branch/ for 2.6.X-rc, and then keep going full steam on
>>> the trunk?
> 
> I think you could branch at ~ rc3 (strictly critical fixes only from
> this point). This way 'next' wouldn't be low-maintenance but the
> release branch would be.
> 
> I.e., the merge window would open at ~ rc3. At 'final', the merge window
> would probably be already closed :-)
> 
> Something like:
> - 2.6.26-rc3: 2.6.27 merge window opens, 2.6.26 - fixes only
> - 1 week later: no core changes for 2.6.27 except fixes (drivers only?)

Yep, that sounds pretty interesting. But It would be better to start something
like ,,slow merge window'' (explained below) around -rc4 where things really
slow down (or used to).

The idea of ,,slow merge window'' would look like:
	- merge only *obvious* (long awaiting) changes;
	- merge stuff (fixes) which comes to -rc releases;
	- merge non-core changes from -mm;

After releasing stable kernel the old style merge window opens.

> 2.6.26* would receive backports from 2.6.27 (cherry-picking? applying
> on 2.6.26 and merging?).
> The "no open regressions" rule would make sense certainly - unless in
> a specific case agreed otherwise.
> 
> Perhaps if needed you could let other people do the final release
> ("stable" extension) and concentrate on the trunk.
> 
>> If I'd have both a 'next' branch _and_ a full 2-week merge window, there's 
>> no upside.
> 
> Shorter cycle is the big upside.
> 
> Perhaps we could start branching later at first - say at 2.6.26-rc5,
> and see how does it work.

-Jacek
