Return-Path: <linux-kernel-owner+w=401wt.eu-S1946525AbXBIP0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946525AbXBIP0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946532AbXBIP0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:26:49 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:60232 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946530AbXBIP0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:26:49 -0500
Message-ID: <45CC9257.8080806@free.fr>
Date: Fri, 09 Feb 2007 16:25:11 +0100
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@timesys.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
       johnstul@us.ibm.com, akpm@osdl.org
Subject: Re: One-shot high-resolution POSIX timer periodically late
References: <fa.4zD54Ie6Ozt0P4YqQSicS+XzXGw@ifi.uio.no>	 <fa.G+/T32f2o1M3+YGLca/O8NaAQyY@ifi.uio.no>	 <fa.6Ua8xjNfLKQEZZgDsoJgPMyww4g@ifi.uio.no>	 <fa.yQlV+WU0TgrJTVqjopa01tgCnT0@ifi.uio.no>	 <fa.ucVrLJ1Lh6FjdBHRglsIUc8/evk@ifi.uio.no>	 <fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no>  <45C75D2D.9010506@free.fr>	 <1170747081.4672.11.camel@twins>  <45C9A8FE.3090705@free.fr> <1170955962.3646.51.camel@chaos>
In-Reply-To: <1170955962.3646.51.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> On Wed, 2007-02-07 at 11:25 +0100, John wrote:
> 
>> Are there people that use the -rt patch set in real industrial applications?
> 
> Yes. But we use a stabilized version of 2.6.16-rt29.
> http://www.osadl.org/projects/downloads/preempt-rt/linux-2.6.16/

Thanks for the pointer.

I'm confused: patch-2.6.16-rt29-tglx3 is dated 2006-09-07, yet there
have been numerous revisions of the -rt patch set since then. Does that
mean that no serious bugs have been found since September? Do the -rt
patch sets for 2.6.17 - 2.6.20 only bring new features and/or adapt the
-rt infrastructure to the newer kernels?

>> It seems that, if an important bug is found in the -rt part, I will have 
>> to either upgrade to the latest kernel, or back port all the -rt changes 
>> to the kernel I chose for my application?
> 
> Yep.

Ouch :-)

I think I'll try my luck with 2.6.20 (it's been working so far).

By the way, I have a question: when I compile glibc for this system,
should I compile it against the vanilla 2.6.20 includes, or against the
patched 2.6.20-rt includes?

Regards.


