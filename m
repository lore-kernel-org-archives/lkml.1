Return-Path: <linux-kernel-owner+w=401wt.eu-S1764146AbXJTNwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764146AbXJTNwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 09:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbXJTNwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 09:52:44 -0400
Received: from rtr.ca ([76.10.145.34]:2985 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbXJTNwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 09:52:43 -0400
Message-ID: <471A082A.9040803@rtr.ca>
Date: Sat, 20 Oct 2007 09:52:42 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression:  2.6.23-rc9 okay, 2.6.23.1 resume problems
References: <4712786B.3040009@rtr.ca> <20071018200531.GB6962@ucw.cz>
In-Reply-To: <20071018200531.GB6962@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> Since upgrading to 2.6.23.1 from 2.6.23-rc9, 
>> resume-from-RAM has been misbehaving here.
>>
>> It takes much (+5-7 seconds) longer to resume 
>> *sometimes*, but not all/most of the time.

I suspend those long delays may have something to do with USB,
as it takes longer for my hub + mouse to come back to life
during the sequence.

But I have since then re-applied the powertop patches,
and the long delays vanished.  Back with -rc9 I normally also
had those powertop fixes, and so this problem could be much
older and was never noticed until I ran without them.

I'm no longer actively investigating, as the delays are
gone (powertop patches), and the crashes are much less frequent
since patching.

Cheers
