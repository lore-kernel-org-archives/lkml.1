Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbXJ3NLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbXJ3NLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 09:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXJ3NLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 09:11:40 -0400
Received: from spirit.analogic.com ([204.178.40.4]:1250 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbXJ3NLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 09:11:38 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 30 Oct 2007 13:11:18.0282 (UTC) FILETIME=[5BB366A0:01C81AF6]
Content-class: urn:content-classes:message
Subject: Re: eradicating out of tree modules
Date: Tue, 30 Oct 2007 09:11:11 -0400
Message-ID: <Pine.LNX.4.61.0710300802100.13303@chaos.analogic.com>
In-reply-to: <47267ADD.2030202@imap.cc>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: eradicating out of tree modules
Thread-Index: Acga9lu/7YNXWG1GSrWA0/AsOErAkw==
References: <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de> <47234F73.3040809@imap.cc> <20071028005555.GC23339@stusta.de> <4724DA20.1010609@imap.cc> <20071028192528.GF7227@stusta.de> <47267ADD.2030202@imap.cc>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Tilman Schmidt" <tilman@imap.cc>
Cc: "Adrian Bunk" <bunk@kernel.org>, "Greg KH" <greg@kroah.com>,
       "Simon Arlott" <simon@fire.lp0.eu>,
       "Chris Wright" <chrisw@sous-sol.org>, <linux-kernel@vger.kernel.org>,
       <linux-security-module@vger.kernel.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       "Giacomo Catenazzi" <cate@debian.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 29 Oct 2007, Tilman Schmidt wrote:

> Am 28.10.2007 20:25 schrieb Adrian Bunk:
>> On Sun, Oct 28, 2007 at 07:51:12PM +0100, Tilman Schmidt wrote:
>>> Am 28.10.2007 02:55 schrieb Adrian Bunk:
>>>> Justifying anything with code with not GPL compatible licences has zero
>>>> relevance here.
>>>>
>>>> And there's value in making life harder for such modules with
>>>> questionable legality. As an example, consider people who experienced
>>>> crashes of "the Linux kernel" caused by some binary-only driver.
>>>> Not that uncommon e.g. with some graphics drivers.
>>>> This harms the reputation of Linux as being stable.
>>> You are mixing up several distinct categories here: "out of tree"
>>> != "non-GPL" != "proprietary" != "of questionable legality" !=
>>> "binary-only" != "causing kernel crashes".
>>
>> "binary-only non-GPL out-of-tree module causes kernel crashes" is a
>> quite common pattern for some popular binary-only modules.
>
> Common, yes. Popular, maybe. The only one, not. Taking that as reason
> for breaking out-of-tree open source modules is throwing out the baby
> with the bathwater.
>
>>>> The solution is not to support proprietary drivers, the solution is to
>>>> get open source replacements.
>>> So how do you propose to "get" those replacements? And what shall
>>> users do during the time this "getting" may take?
>>
>> They should swamp the hardware vendors with requests for releasing
>> hardware specifications.
>
> They are doing that already. But somehow it fails to magically cause
> open source drivers to spring into existence immediately. The crucial
> word here is *time*.
>
>> Or even better buy their hardware from a competitor.
>
> Hmmm. "Your existing hardware isn't supported anymore, buy new one?"
> I thought that was a Microsoft line. (SCNR)
>
>>>> If it's low quality code doing something useful - well, how many hundred
>>>> people are on Greg's list only waiting for some driver they could write?
>>> No idea. Obviously not enough to actually solve the problem.
>>
>> Greg has just begins with getting this started.
>
> Exactly. Again, the problem is time. Deliberately breaking external
> modules now and promising an in-tree alternative for later leaves
> users out in the cold. That won't do much to improve the reputation
> of Linux.
>
>>> What solution do you propose?
>>
>> You list the drivers you currently have in mind at the Linux Driver
>> Project [1].
>
> They are all there already.
>
>> Noone proposed to make the existance of out-of-tree modules completely
>> impossible - but it is a fact that derives directly from the Linux
>> kernel development model that thre's no stable API for out-of-tree
>> modules, and therefore each new kernel breaks many of them.
>
> Granted.
>
>> Once you accept this fundamental fact there's not much point in arguing
>> that changes that break out-of-tree modules should be fewer.
>
> Granted. But that's not the point I was arguing anyway.
>
> There is still a point in arguing that breaking out-of-tree modules
> is not a goal. It's acceptable collateral damage if there is a good
> reason for a change, but it doesn't by and in itself constitute such
> a reason. That's why I'm taking exception with your statement in
> <20071024223124.GI30533@stusta.de>:
>> [...] even though it might sound harsh breaking
>> external modules and thereby making people aware that their code should
>> get into the kernel is IMHO a positive point.
>
> Breaking external modules is *not* positive. It's acceptable, but
> everything else being equal it's still better to avoid it.
>
>>>> Let me repeat that Greg has said he has hundreds of volunteers for such
>>>> tasks.
>>> Even with hundreds of volunteers, your proposed solution of just
>>> rewriting *all* external code in a way fit for inclusion into the
>>> kernel is an unachievable goal. Just look at the list on
>>> http://linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
>>> and try to answer why each of them is still out of tree.
>>> Hint: In most cases it's neither out of malice nor stupidity on
>>> the authors' part.
>>
>> There are different problems why different drivers are not (yet)
>> included in the kernel, but which ones don't have any possible solution?
>
> I'm convinced all of them have possible solutions. The challenge
> is to turn a possible solution into an actual one. And again, the
> problem is time.
>
>> And if you compare the numbers you'll see that Greg has on average a
>> handful of volunteers for one driver.
>
> Not every problem can be solved faster by throwing more people at
> it. Take mISDN as an example. Its developers have stated the goal
> of inclusion in the main kernel tree years ago and it's still not
> there. Deliberately breaking this external module "to make people
> aware that their code should get into the kernel" would only delay
> this goal even more. But sending them a handful of new volunteers
> now would probably constitute the proverbial "adding manpower to a
> late project".
>
>> The most important question is still:
>>
>> Why should there always be out-of-tree code that fills a real need not
>> satisfied by any in-tree code?
>
> Because every in-tree code starts as out-of-tree code, so as long
> as there's development at all there's always a certain amount of
> code which isn't in-tree yet - or of which it isn't even sure yet
> whether it will get in-tree.
>
> HTH
>
> -- 
> Tilman Schmidt                          E-Mail: tilman@imap.cc
> Bonn, Germany
> Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
> Ungeÿÿffnet mindestens haltbar bis: (siehe Rÿÿckseite)

I'm sure that the majority of Linux users would never acquire
the 4-board assembly that we use to acquire X-Ray data and
generate real-time images for the baggage scanners in use
at the world's major airports. That assembly, containing
numerous CPUs and other high-speed pipelined stuff would
cost the user about  US$100,000 so I'm pretty sure that
are not many takers so it is very unlikely that any modules
to support it would never get into the mainstream kernel.

If we can't build out-of-tree modules to support this stuff,
then we can't use Linux. Already, we've complied with the
GPL terms that we will give our module code to anybody,
even though it is useless without our hardware which I'm
certain they are not going to buy.

Linux is NOT just a desk-top OS. It has many other uses.
It should scare the hell out of everybody to know that
Windows CE is being used in Aircraft flight directors.
We need to maintain the viability of Linux in dedicated
or embedded operations so that it will eventually replace
such stuff. Over the years, there has been a continual
attempt to obfuscate Linux to make it more difficult to
use out-of-tree. Further, the continual internal changes,
which don't affect anything but compatibility and the
ability to compile (changes for the sake of changes),
has caused many engineers to lose all their hair. Stop!
This has gone far enough. Right now we cannot upgrade
past linux-2.6.16.24 just because some kernel hacker
decided so. This is bad, real bad.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
My book : http://www.AbominableFirebug.com/
_

****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
