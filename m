Return-Path: <linux-kernel-owner+w=401wt.eu-S1422659AbXC2WEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422659AbXC2WEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422665AbXC2WEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:04:31 -0400
Received: from smtp.ono.com ([62.42.230.12]:35661 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422659AbXC2WEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:04:30 -0400
Date: Fri, 30 Mar 2007 00:01:11 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Inlining can be _very_bad...
Message-ID: <20070330000111.620aaaab@werewolf-wl>
In-Reply-To: <20070329175254.GC14134@stusta.de>
References: <20070329011838.6e832615@werewolf-wl>
	<20070329175254.GC14134@stusta.de>
X-Mailer: Claws Mail 2.8.1cvs62 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 19:52:54 +0200, Adrian Bunk <bunk@stusta.de> wrote:

> On Thu, Mar 29, 2007 at 01:18:38AM +0200, J.A. Magallón wrote:
> > Hi all...
> > 
> > I post this here as it can be of direct interest for kernel development
> > (as I recall many discussions about inlining yes or no...).
> > 
> > Testing other problems, I finally got this this issue: the same short
> > and stupid loop lasted from 3 to 5 times more if it was in main() than
> > if it was in an out-of-line function. The same (bad thing) happens if
> > the function is inlined.
> >...
> > It looks like is updating the stack on each iteration...This is -march=opteron
> > code, the -march=pentium4 is similar. Same behaviour with gcc3 and gcc4.
> > 
> > tst.c and Makefile attached.
> > 
> > Nice, isn't it ? Please, probe where is my fault...
> 
> The only fault is to post this issue here instead of the gcc Bugzilla.
> 

Sorry, my intention was just something like 'take a look at your
reduction-like code, perhaps its sloooow', something like checksum
funtions in tcp or raid that are inlined expecting to be faster
and in fact they are slower...

> In your example the compiler should produce code not slower than with 
> the out-of-line version when inlining. If it doesn't the bug in the 
> compiler resulting in this should be fixed.
> 

That's what I expected, but...
Going to gcc bugzilla...

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam06 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #2 SMP PREEMPT
