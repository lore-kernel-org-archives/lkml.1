Return-Path: <linux-kernel-owner+w=401wt.eu-S1761835AbXHFIz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835AbXHFIz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 04:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbXHFIzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 04:55:49 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:53442 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbXHFIzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 04:55:48 -0400
Message-ID: <46B6E210.9090502@free.fr>
Date: Mon, 06 Aug 2007 10:55:44 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: Old -rt patches
References: <46B0B7A4.8060805@free.fr>
In-Reply-To: <46B0B7A4.8060805@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> I wrote a Linux app where I need high-resolution timers. I went all the 
> way and installed the -rt patch, which includes the -hrt patches, as far 
> as I understand.
> 
> Since I could not afford to change kernels with every new release, I 
> decided to track the 2.6.20 branch (arbitrarily).
> 
> At this point I'm using 2.6.20.7-rt8 (-rt8 was the last patch to the 
> 2.6.20 branch). (I see 2.6.20 is already up to .15)
> 
> I see a lot of patches going into the -rt patch, but development moved 
> on to 2.6.21, then 2.6.22, and now 2.6.23, following mainline.
> 
> I'm not a kernel hacker, so I don't claim to understand the patches, but 
> the comments sound like a few bugs are fixed here and there. I can't 
> tell whether these bugs also exist in previous kernels or only appeared 
> in newer kernels. Even if I knew, I probably wouldn't have the expertise 
> to back-port the patch.
> 
> I'm seeing weird behavior in my app, when it has been running 2-4 days. 
> The timers start to act out, and all hell breaks loose. Basically, I 
> have no idea what's going on...
> 
> My question is: is it possible that there is a bug in 2.6.20-rt8 that 
> has been fixed in subsequent -rt patches (there's a 2.6.21.6-rt21 and a 
> 2.6.22.1-rt9)? In other words, if I give 2.6.21.6-rt8 or 2.6.22.1-rt9 a 
> spin, is it possible that my weird behavior disappears?
> 
> I'm not saying that it's impossible for the bug to be in my app, but the 
> app is small enough that I'm fairly confident there's no problem there.

Would anyone care to comment?

Perhaps I could also test a different strategy, such as xenomai?
http://www.xenomai.org/

Regards.
