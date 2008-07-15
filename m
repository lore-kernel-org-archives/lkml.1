Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbYGOUOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbYGOUOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbYGOUOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:14:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:52222 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYGOUOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BQtER+6GDgIWr4CtLHMhTe/SRQRTT/vvCXAeQuTK+GxLpFN2K5L5VaU1TO6Rlazhsm
         pP8JXo6xLEwpcZ8QSM+zvmgaz8AKz9/duw+81D25VEM7kYRk1TW77jYFO0mrssMmn7nR
         jOQrOVDBTpLcUEySMA8Tcr0FzVKuj32pF92Eg=
Message-ID: <19f34abd0807151314r7462ecc4n8483c7e9fd52769f@mail.gmail.com>
Date: Tue, 15 Jul 2008 22:14:39 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull] RCU updates for v2.6.27
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151037060.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080714152045.GA29159@elte.hu>
	 <alpine.LFD.1.10.0807151037060.3017@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 7:38 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 14 Jul 2008, Ingo Molnar wrote:
>>
>> [ NOTE: due to merge interaction please pull this after
>>   kmemcheck-for-linus. The shortlog is relative to kmemcheck-for-linus. ]
>
> Hmm. I really wanted to wait with kmemcheck, which is huge and I'm not
> entirely convinced yet. So now I'll have to wait for these fixes too, for
> some reason that isn't clear.

Hey, give us some credit; at least it's disabled by default ;-)

But yeah, I'll continue to improve it and hopefully get it in better
shape for next time, especially with regards to SMP support. Maybe we
can finally have Andrew's review too, if he's not too busy giving all
these talks and whatnot. Some of the things we've actually fixed up
since last time include impact on the slab code,
CodingStyle/checkpatch issues, and the splitting the huge single file
of code into its own directory to make it more manageable. Oh, and I
believe 64-bit support is new as well.

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
