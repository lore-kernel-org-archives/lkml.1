Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbYFNIjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbYFNIjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 04:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbYFNIjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 04:39:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:13268 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbYFNIjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 04:39:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CoQvCSOgRy2oitmsQEo5Hg2Omxu9dGTlvab6DYZWei0kF8KqZj0aiWzA/YdTLYYBB4
         /BIypJOL0/mZfoqmXL2lLIYPyvyVE/iVmQKNUCl+wNQGrc8XLzZFTIOfOQ+5QxJ39ORc
         G8jijynV9/4p8i90TrmeEaQ89up5Cf5UgtL0w=
Message-ID: <19f34abd0806140139i70a5056ehbd8a6f5df81549e4@mail.gmail.com>
Date: Sat, 14 Jun 2008 10:39:03 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC][PATCH] kmemcheck: divide and conquer
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080614063114.GA24188@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613140057.GA25833@damson.getinternet.no>
	 <20080614063114.GA24188@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 8:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> The RFC part: Is this a good thing to do? I personally hate the
>> 4000-line files that are so commonly found in the kernel, and
>> therefore prefer this split-up. On the other hand, C lacks namespaces,
>> which sometimes leads to some really long and ugly names just to
>> prevent clashes in the future. But it's your call, I'll just do
>> whatever it takes to get in... ;-)
>
> it's a very nice splitup! :-) [ Any Git coordinates to pick it up? ]

Ah, thanks, that's just what I wanted to hear! :-D

This particular commit can be found in the "against-v2.6.26-rc4"
branch of kmemcheck.git:

http://git.kernel.org/?p=linux/kernel/git/vegard/kmemcheck.git;a=commit;h=8c67b9b8005a518ce003943a64c37a9fc2c84485

But for the newer versions, I've merged it into the "kmemcheck core"
commit. To pick up the whole series, you can either check out the
against-v2.6.26-rc5 branch (which is frozen), or you can check out the
"current" branch which is the most recent rebase (against v2.6.26-rc6,
but not yet frozen):

$ git remote add kmemcheck
git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git
$ git fetch kmemcheck
$ git checkout kmemcheck/current

Just a small disclaimer: It's not VERY well tested, so build breakage
may occur with this shuffle. It really shouldn't, though.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
