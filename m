Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZCUKHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZCUKHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZCUKHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:07:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40475 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbZCUKHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:07:02 -0400
Date: Sat, 21 Mar 2009 11:06:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
Message-ID: <20090321100636.GD7201@elte.hu>
References: <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain> <49BD225C.4070305@krogh.cc> <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain> <49BD4B2D.7000501@krogh.cc> <alpine.LFD.2.00.0903151146550.3131@localhost.localdomain> <49BD5C7C.2060605@krogh.cc> <49BEA1AD.1090901@krogh.cc> <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain> <49C4AF5D.50107@krogh.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C4AF5D.50107@krogh.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jesper Krogh <jesper@krogh.cc> wrote:

> Linus Torvalds wrote:
>>
>> On Mon, 16 Mar 2009, Jesper Krogh wrote:
>>> you were right. It works. No resets so far.
>>
>> Goodie.
>>
>> Here's a slightly cleaned-up patch that removes the debug messages, and 
>> also re-organizes the code a bit so that it actually uses the "better 
>> than 500 ppm" as the way to decide when to stop calibrating.
>
> Can we ship:
> commit a6a80e1d8cf82b46a69f88e659da02749231eb36
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Mar 17 07:58:26 2009 -0700
>
>     Fix potential fast PIT TSC calibration startup glitch
>
> and
> commit 9e8912e04e612b43897b4b722205408b92f423e5
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Mar 17 08:13:17 2009 -0700
>
>     Fast TSC calibration: calculate proper frequency error bounds
>
>
> to the 2.6.28-stable series..  The first one needed to apply the second.

Yes, would be nice to have these fixes in .28.9.

	Ingo
