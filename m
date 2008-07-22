Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYGVA4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYGVA4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYGVA4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:56:33 -0400
Received: from usmail2.us.checkpoint.com ([216.200.240.146]:44712 "EHLO
	us.checkpoint.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752268AbYGVA4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:56:32 -0400
Message-ID: <48852F67.8090800@la.checkpoint.com>
Date: Mon, 21 Jul 2008 21:52:55 -0300
From: "Rodrigo Rubira Branco (BSDaemon)" <rbranco@la.checkpoint.com>
Reply-To: rbranco@la.checkpoint.com
Organization: Check Point
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
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
       alan@lxorguk.ukuu.org.uk, "'Alan Cox'" <alan@redhat.com>,
       caglar@pardus.org.tr, casey@schaufler-ca.com, spender@grsecurity.net,
       pageexec@freemail.hu, rodrigo@kernelhacking.com
Subject: Re: [stable] Linux 2.6.25.10 (resume)
References: <20080701151057.930340322@mini.kroah.org> <200807021257.47593.caglar@pardus.org.tr> <20080702144149.GA16850@suse.de> <200807021809.07679.caglar@pardus.org.tr> <005001c8e6f8$ac0955f0$a6181fac@ad.checkpoint.com> <20080716044905.GA9033@suse.de> <4880A3B1.3050103@la.checkpoint.com> <20080719221343.GA5578@suse.de>
In-Reply-To: <20080719221343.GA5578@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH escreveu:
> On Fri, Jul 18, 2008 at 11:07:45AM -0300, Rodrigo Rubira Branco (BSDaemon) wrote:
>   
>> --- SecurityBugs.orig	2008-07-16 23:46:09.000000000 -0300
>> +++ SecurityBugs	2008-07-17 14:58:32.000000000 -0300
>> @@ -1,7 +1,7 @@
>> -Linux kernel developers take security very seriously.  As such, we'd
>> -like to know when a security bug is found so that it can be fixed and
>> -disclosed as quickly as possible.  Please report security bugs to the
>> -Linux kernel security team.
>> +Linux kernel developers take security very seriously, in exactly the 
>> +same way we do with any other bugs.  As such, we'd like to know when 
>> +a security bug is found so that it can be fixed as soon as possible.
>> +Please report security bugs to the Linux kernel security team.
>>     
>
> I guess what is getting everyone's panties all in a bind is the term
> "disclosed", right?  Why not just drop this word from the sentence
> instead of rewording it so much?
>   
No, it's not ;)  The problem is the policy of normal bugs = security 
bugs.  If it's clear in the documentation, it will make people who need 
to backport patches aware of that and then they will need to care by 
themselves.

The idea of start a project to keep track of that is not bad, but the 
problem is it's almost impossible to keep track of everything.  The 
kernel developers knows about the bugs when they correct it, so just 
note as a security problem is not a big issue (but we already accepted 
it will not be done).  Maybe if you guys accept to note it as a security 
issue at least to a group of people who can work on document it, it's 
cool to me ;)
>   
>> @@ -14,23 +14,24 @@
>>  As it is with any bug, the more information provided the easier it
>>  will be to diagnose and fix.  Please review the procedure outlined in
>>  REPORTING-BUGS if you are unclear about what information is helpful.
>> -Any exploit code is very helpful and will not be released without
>> -consent from the reporter unless it has already been made public.
>> +Any exploit code is very helpful and will not be released.
>>     
>
> I don't see why this needs to be changed, sometimes we do release
> exploit code to third parties that ask us nicely and the reporter allows
> us to.
>   
Great, I agreed with that and already sent another version changing this 
sentence.

>   
>>  2) Disclosure
>>  
>>  The goal of the Linux kernel security team is to work with the
>>  bug submitter to bug resolution as well as disclosure.  We prefer
>> -to fully disclose the bug as soon as possible.
>>     
>
> Ah, again, it's the "fully disclose" that is causing panties to ride
> high.  And again, we are disclosing the bug with the real fix and the
> code in question.  We just seem to differ on what people consider
> "fully" it seems.  I think the people liking that term these days
> consider that you must release exploit and other detailed information.
>
>   
No, that's not true... We just want a sentence in the fix saying a 
security issue have been fixed.  Not a detailed explanation, so the 
developers don't need to wast important time trying to understand 
security problems.  The issue is that they know it's a security fix but 
they don't put that and sometimes they remove any reference to that ;)
> I disagree with this and feel that our current policy of fixing bugs and
> releasing full code is pretty much the same thing as we are doing today,
> although I can understand the confusion.  How about this rewording of
> the sentance instead:
>
> 	We prefer to fix and provide an update for the bug as soon as
> 	possible.
>
> So a simple 1 line change should be enough to stem this kind of argument
> in the future, right?
>   
I really feel more confortable with the new version that I just sent - 
it's more cleaver about how it's handled... Please, give-me your 
insights on it too...


cya,


Rodrigo (BSDaemon).
