Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978Ab0A2R16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0A2R16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316Ab0A2R15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:27:57 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:60398 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161Ab0A2R15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:27:57 -0500
X-Trace: 336164763/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.93.110/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.93.110
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtwAAPeoYktPRV1u/2dsb2JhbAAI2kCEQgQ
X-IronPort-AV: E=Sophos;i="4.49,369,1262563200"; 
   d="scan'208";a="336164763"
Date: Fri, 29 Jan 2010 17:27:56 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Mel Gorman <mel@csn.ul.ie>
cc: Mark Lord <kernel@teksavvy.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1, 
In-Reply-To: <20100129154653.GJ7139@csn.ul.ie>
Message-ID: <alpine.LSU.2.00.1001291716520.10968@sister.anvils>
References: <4B5FA147.5040802@teksavvy.com> <4B610FDA.50104@teksavvy.com> <4B6113C7.201@teksavvy.com> <201001281152.20352.rjw@sisk.pl> <4B61964F.6060307@teksavvy.com> <4B619C6D.9030205@teksavvy.com> <20100128142437.GA7139@csn.ul.ie> <4B62E904.9020401@teksavvy.com>
 <20100129154653.GJ7139@csn.ul.ie>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010, Mel Gorman wrote:
> On Fri, Jan 29, 2010 at 08:56:20AM -0500, Mark Lord wrote:
> 
> > I'll leave it running for another day or so, and then perhaps revert
> > the one patch to see which of the two things (new kernel, or patch)
> > is responsible for the difference.
> >
> 
> Thanks, I'd appreciate it. While I'm reasonably confident the problem is
> with MIGRATE_RESERVE not being free as intended and that the patch fixes
> it, I'd like more proof.

You're more confident about that than I am!  It will be very satisfying
if my patch turns out to make the difference, but still surprising to me.

Thank you for taking the time on this, Mark: I too would appreciate it
if you could later determine whether it's new kernel or patch solving it.

> 
> Hugh, can I get a signed-off-by on that patch please? I can improve the
> changelog if you like and send it to Andrew for merging if you like.

I was adjusting the changelog and about to send direct to Linus Cc stable
in a few minutes, since I'm guessing there might be a 33-rc6 today, which
would be a pity to miss.

Whatever my reluctance to assume it's the fix to Mark's problem (which I'm
not mentioning in the changelog), we are both sure it's a valid bugfix.

Hugh
