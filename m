Return-Path: <linux-kernel-owner+w=401wt.eu-S1762497AbXEKWl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762497AbXEKWl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 18:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbXEKWlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 18:41:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:25573 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbXEKWlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 18:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nunoUm5O6L1iaGknFAHEGHPwSw6Fgrw6rfj96mz6ZoWiH2TV4/YIk63nfIBPBluCtH5+dCv6belv9aXsT18G3/ywz+E+s3gnTq2JQWXaLERuhbeiRKz07LQpJ5a6UEbSTtfZXhqTz+9uQcp05KwJCNji+OTTz86kr6f43v2h120=
Message-ID: <a36005b50705111541s823eefp105e7284923fac45@mail.gmail.com>
Date: Fri, 11 May 2007 15:41:18 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND] PIE randomization
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Jan Kratochvil" <honza@jikos.cz>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20070511133651.63f8a14d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
	 <20070511125629.3df919cf.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
	 <20070511133651.63f8a14d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> erm, I was being funny.  If you randomize a binary it won't run any more.
> cp /dev/random /bin/login.  Oh well.
>
> My point is, we're not being told what is being randomized here.  Is it the
> virtual starting address of the main executable mmap?  Of the shared
> libraries also?  Is it the stack location?  What?

PIE = Position Independent Executable, that's how I named them.

These are not regular executables, they are basically DSOs but usually
compiled with -fpie/-fPIE instead of -fpic/-fPIC and linked with -pie
instead of -shared to allow the compiled and linker perform more
optimizations.

See section 5 in

  http://people.redhat.com/drepper/nonselsec.pdf

Jan unfortunately Ingo's document which doesn't really explain it.
