Return-Path: <linux-kernel-owner+w=401wt.eu-S1751589AbXBOGYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbXBOGYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 01:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbXBOGYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 01:24:10 -0500
Received: from mail.velocitynet.com.au ([203.17.154.25]:56080 "EHLO
	m0.velocity.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbXBOGYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 01:24:09 -0500
Message-ID: <45D3FC67.3000903@iinet.net.au>
Date: Thu, 15 Feb 2007 17:23:35 +1100
From: Ben Nizette <ben.nizette@iinet.net.au>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: v j <vj.linux@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
In-Reply-To: <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v j wrote:
> This is in reference to the following thread:
> 
> http://lkml.org/lkml/2006/12/14/63
> 
> I am not sure if this is ever addressed in LKML, but linux is _very_
> popular in the embedded space. We (an embedded vendor) chose Linux 3
> years back because of its lack of royalty model, robustness and
> availability of infinite number of open-source tools.
[...]
> However we have a worrying trend here. If at some point it becomes
> illegal to load our modules into the linux kernel, then it is
> unacceptable to us. We would have been better off choosing VxWorks or
> OSE 3 years ago when we made an OS choice. The fact that Linux is
> becoming more and more closed is very very alarming.
> 
Question to the world here:  Distros make, as a matter of course, a 
series of modifications to the Linux Kernel so that their modules or 
features work.  What stops VJ making a patchset which effectively 
s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/g 's the kernel source then 
distributing that under the GPL?  He then supplies his un-GPL'd modules 
to the world which just happen to only run on the modified kernel.  I've 
read the GPL of course (IANAL though) and I can't see what this violates 
except the /spirit/ of the license.  Don't get me wrong, I'm strongly 
against anyone doing what I just mentioned, I believe it to be immoral 
taking someone's GPL'd code and mangling it in such a way.  I speak as 
an embedded developer myself whose company decided that running our code 
under Linux and distributing our code under the GPL was far preferable 
to running closed-source software on a closed-source platform.

I'll finish off to VJ:  If you want to be alarmed, go ahead and switch 
to VxWorks, the Linux community will live on.  It might have a smaller 
user-base in embedded-land but that's the nature of the beast.  A large 
user-base doesn't mean much to something like linux unless it comes with 
a large, open-source-minded developer-base.

--Ben.
