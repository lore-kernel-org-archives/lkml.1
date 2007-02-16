Return-Path: <linux-kernel-owner+w=401wt.eu-S1945935AbXBPPeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945935AbXBPPeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945934AbXBPPeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:34:14 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:49065 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945922AbXBPPeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:34:13 -0500
Message-ID: <45D5CEE5.9010505@nortel.com>
Date: Fri, 16 Feb 2007 09:33:57 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Manu Abraham <abraham.manu@gmail.com>, Mws <mws@twisted-brains.org>,
       v j <vj.linux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <200702151254.39058.mws@twisted-brains.org> <1a297b360702150451n3dca1140ra6827cfde020eed5@mail.gmail.com> <Pine.LNX.4.61.0702150913020.1735@chaos.analogic.com> <200702160819.l1G8JnmZ013706@turing-police.cc.vt.edu>
In-Reply-To: <200702160819.l1G8JnmZ013706@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2007 15:34:02.0043 (UTC) FILETIME=[E259A0B0:01C751DF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

> Actually, the *real* reason embedded systems end up using old versions is
> much simpler.
> 
> They start developing their code on release 2.X.Y, and they keep their code
> out-of-tree.  Then, when they come up for air, and it's at 2.X.(Y+15), they
> discover that we weren't kidding when we shipped stable_api_nonsense.txt,
> and since their code isn't in the tree, they have to do all the API cleanup
> themselves, because no flock of nit-picking kernel janitor monkeys swarmed
> over their code and magically fixed it up for them.

That's one reason.  Another reason is that maybe the embedded system 
code is doing stuff that's so special purpose that it doesn't make 
*sense* for it to go into mainline.  We've done stuff like this.  We've 
also done stuff where we tried to get it into mainline but the 
maintainers didn't want it.

Yet another reason is that we need to pick a release and stay on it, 
because we need to get our four hardware vendors and three software 
vendors to all agree that they will support that particular release.

I would *love* to track the mainline kernel.  However, it simply can't 
be done when you're using hardware that isn't supported yet by mainline 
and you're relying on the vendor to provide a patch to make the kernel 
even boot.

Chris
