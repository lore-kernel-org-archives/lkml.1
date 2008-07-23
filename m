Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbYGWEeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbYGWEeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 00:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYGWEd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 00:33:58 -0400
Received: from ns.suse.de ([195.135.220.2]:44627 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbYGWEd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 00:33:57 -0400
Date: Tue, 22 Jul 2008 21:27:37 -0700
From: Greg KH <gregkh@suse.de>
To: "Rodrigo Rubira Branco (BSDaemon)" <rbranco@la.checkpoint.com>
Cc: Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, greg@kroah.com,
       "'Justin Forbes'" <jmforbes@linuxtx.org>,
       "'Zwane Mwaikambo'" <zwane@arm.linux.org.uk>,
       "'Theodore Ts'o'" <tytso@mit.edu>,
       "'Randy Dunlap'" <rdunlap@xenotime.net>,
       "'Dave Jones'" <davej@redhat.com>,
       "'Chuck Wolber'" <chuckw@quantumlinux.com>,
       "'Chris Wedgwood'" <reviews@ml.cw.f00f.org>,
       "'Michael Krufky'" <mkrufky@linuxtv.org>,
       "'Chuck Ebbert'" <cebbert@redhat.com>,
       "'Domenico Andreoli'" <cavokz@gmail.com>, "'Willy Tarreau'" <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, caglar@pardus.org.tr, casey@schaufler-ca.com,
       spender@grsecurity.net, pageexec@freemail.hu, rodrigo@kernelhacking.com
Subject: Re: [stable] Linux 2.6.25.10 (resume)
Message-ID: <20080723042737.GC6784@suse.de>
References: <20080701151057.930340322@mini.kroah.org> <200807021257.47593.caglar@pardus.org.tr> <20080702144149.GA16850@suse.de> <200807021809.07679.caglar@pardus.org.tr> <005001c8e6f8$ac0955f0$a6181fac@ad.checkpoint.com> <20080716044905.GA9033@suse.de> <4880A3B1.3050103@la.checkpoint.com> <20080719101140.GB20802@devserv.devel.redhat.com> <48852E4D.3050405@la.checkpoint.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48852E4D.3050405@la.checkpoint.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 09:48:13PM -0300, Rodrigo Rubira Branco (BSDaemon) wrote:
> Alan Cox escreveu:
>>> @@ -1,7 +1,7 @@
>>> -Linux kernel developers take security very seriously.  As such, we'd
>>> -like to know when a security bug is found so that it can be fixed and
>>> -disclosed as quickly as possible.  Please report security bugs to the
>>> -Linux kernel security team.
>>> +Linux kernel developers take security very seriously, in exactly the 
>>> +same way we do with any other bugs.  As such, we'd like to know when +a 
>>> security bug is found so that it can be fixed as soon as possible.
>>> +Please report security bugs to the Linux kernel security team.
>>>     
>>
>> NAK this. If the fix is not clear and the bug not too serious it is better
>> to disclose it than fail to fix it. The security team does not usually fix 
>> the
>> bugs, the experts in the various bits of code do.
>>   
> ACK ;)  Changed the sentence.  Tks.
>
>>> -Any exploit code is very helpful and will not be released without
>>> -consent from the reporter unless it has already been made public.
>>> +Any exploit code is very helpful and will not be released.
>>>     
>>
>> NAK this too. If someone releases an exploit publically or it leaks we
>> want to be able to freely share it too. Your proposal would mean any but
>> those dumb enough to agree to this could share it. That is why the unless 
>> made
>> public is part of every generic NDA document on the planet.
>>   
> Agreed.  Changed the sentence.  Tks.
>> The rest needs Linus to return from holiday for discussion and that'll
>> be a week or two. In the meantime you might want to define "disclose" as
>> I don't think we all agree on what it means as you've not defined who is 
>> and
>> isn't the linux security team and/or its helpers.
> Cool.

> --- SecurityBugs.orig	2008-07-16 23:46:09.000000000 -0300
> +++ SecurityBugs	2008-07-21 07:28:01.000000000 -0300
> @@ -1,7 +1,9 @@
> -Linux kernel developers take security very seriously.  As such, we'd
> -like to know when a security bug is found so that it can be fixed and
> -disclosed as quickly as possible.  Please report security bugs to the
> -Linux kernel security team.
> +Linux kernel developers take security very seriously, in exactly the 
> +same way we do with any other bugs.  As such, we'd like to know when 
> +a security bug is found so that it can be fixed as soon as possible by
> +the experts in this portion of the kernel code.
> +
> +Please report security bugs to the Linux kernel security team.

You have trailing spaces in your patch, please run all patches through
scripts/checkpatch.pl to catch stuff like this.

> @@ -14,23 +16,26 @@
>  As it is with any bug, the more information provided the easier it
>  will be to diagnose and fix.  Please review the procedure outlined in
>  REPORTING-BUGS if you are unclear about what information is helpful.
> -Any exploit code is very helpful and will not be released without
> -consent from the reporter unless it has already been made public.
> +Any exploit code is very helpful and will not be released by our team
> +unless already made public.  The exploit code may be shared with third
> +parties to facilitate a fix or to verify the vulnerability.

Your two changed sentances are contradictory.
What is wrong with the original wording?

>  2) Disclosure
>  
>  The goal of the Linux kernel security team is to work with the
>  bug submitter to bug resolution as well as disclosure.  We prefer
> -to fully disclose the bug as soon as possible.  It is reasonable to
> +to not disclose the bug, since we believe any kind of bug deserves the
> +same attention and will be quickly patched.  It is reasonable to

No, again, you are using the word "disclose" in an odd way here.

Of course the bug is "disclosed" in that it is made public, "here's a
fix for foo breaking".

So this wording change is not right.

>  delay disclosure when the bug or the fix is not yet fully understood,
>  the solution is not well-tested or for vendor coordination.  However, we
>  expect these delays to be short, measurable in days, not weeks or months.
>  A disclosure date is negotiated by the security team working with the
> -bug submitter as well as vendors.  However, the kernel security team
> -holds the final say when setting a disclosure date.  The timeframe for
> -disclosure is from immediate (esp. if it's already publically known)
> -to a few weeks.  As a basic default policy, we expect report date to
> -disclosure date to be on the order of 7 days.
> +bug submitter as well as vendors if the submitter wants to disclose.  

Again, trailing spaces.

What was wrong with the original wording?

thanks,

greg k-h
