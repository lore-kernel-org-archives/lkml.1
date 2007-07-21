Return-Path: <linux-kernel-owner+w=401wt.eu-S934538AbXGUN2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538AbXGUN2q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 09:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbXGUN2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 09:28:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:63551 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbXGUN2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 09:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pIQghWgqDynBMILLa/4uvPzbQ8ai2kcKd0O78avi9Qavu1lxVdiSQLeHEPIOsrvEH3nD/zWw9bDg0nzEndUwIv0HQKS+aFbiWjPFAELmTLy8Rajv2OgFtN/QOZAd9eTNyHv8DbJ1LfsBdx4qJQbO+UbmVIsrPo5mH2eKx0D+pNY=
Message-ID: <5d6222a80707210628y232adb63l7467b1e34f592cdb@mail.gmail.com>
Date: Sat, 21 Jul 2007 10:28:34 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>, "Andrew Morton" <akpm@osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Arjan van de Ven" <arjan@infradead.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <200707211028.32465.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184970779.4012.38.camel@chaos> <200707210737.59552.ak@suse.de>
	 <1185005750.4012.100.camel@chaos> <200707211028.32465.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Andi Kleen <ak@suse.de> wrote:
> [of which several just #include <asm-generic/foo.h] ?
>
> I suppose msidef.h and hypertransport.h should be shared agreed;
> for the others it is not obvious. spinlock_types will likely fork soon;
> it used to be different in the past already and will be again.
Why will it fork? I don't think it will ever happen that the trees
will have large pieces that _has_ to be different one from the other.
So if it's forking to achieve some benefits, why can't i386 get the
benefits too? I think this is the whole point here.

Surely as it is today (and just because it wasn't merged earlier and
the past!), the x86_64 tree has a bunch of things that are quite
better structured than the i386 (and maybe vice-versa, but I must
admit that unlike Steven Roasted, I like the x86_64 a lot more). But
in the long term,  it tends to just get the best of each picked up.

And oh yeah, i386 is older, has a lot more corner cases, but even if
it does count against the merge, we have a net win at the end.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
