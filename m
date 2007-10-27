Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbXJ0Ord@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbXJ0Ord (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbXJ0OrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:47:24 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35583 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbXJ0OrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:47:22 -0400
X-Sasl-enc: Oz635+Ban9jRzdAHChvC2BQ3sotGO5rfAxHTh9jAesj8 1193496441
Message-ID: <47234F73.3040809@imap.cc>
Date: Sat, 27 Oct 2007 16:47:15 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Greg KH <greg@kroah.com>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: eradicating out of tree modules (was: : Linux Security *Module* Framework)
References: <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de>
In-Reply-To: <20071026232653.GF30533@stusta.de>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk schrieb:
> On Fri, Oct 26, 2007 at 11:46:39AM +0200, Tilman Schmidt wrote:
>> On Thu, 25 Oct 2007 19:56:47 -0700, Greg KH wrote:
>>> On Fri, Oct 26, 2007 at 01:09:14AM +0200, Tilman Schmidt wrote:
>>>> [...] Once you admit that there is code which, for very good
>>>> reasons, won't ever be accepted into the mainline kernel tree, what you
>>>> are saying amounts to: "Code that isn't fit to be included in the
>>>> mainline kernel isn't fit to exist at all."
>>> What kind of code is not accepted into the mainline kernel tree for good
>>> reasons?
>> - proprietary code
> 
> It's unclear whether distributing not GPL compatible modules is legal
> at all.

We're neither talking about distribution nor legal aspects, but
about existence. But anyway, you seem to agree with me that there
are very good reasons for not including these in the kernel.

> And they are definitely not "very good reasons" for doing anything in 
> the kernel.

There is a big difference between "not doing anything to help"
and "actively doing something to make life difficult for". The
former is undoubtedly legitimate. It's the latter we're
discussing here.

>> - unmaintained code
> 
> Unmaintained code in the kernel has a realistic chance of being usable 
> for 5 years.
> 
> Unmaintained external code is quite likely to be unusable after
> at most one year.

Then why is "being unmaintained" being toted as an argument
*against* inclusion in the kernel?

>> - code conflicting with existing kernel structure or policy
>> - code in which the concerned subsystem maintainers see no benefit
> 
> Let's fix the problems, not work around them.

That's certainly better, but not always possible. Do you
agree with me that if it isn't, then that's a very good
reason for not including that code in the kernel?

> There is a conflict between getting code included and ensuring some 
> minimum quality of the kernel, but in many cases we could try better.

Correct. Again, you appear to agree with my statement that
for some code there are very good reasons not to include it
in the kernel.

> And when there's a good reason for a kernel policy, then code that
> violates this policy is not a "very good reason" for anything.

>> - code which its author is unable and/or unwilling to convert to
>>   kernel coding standards
>> - code whose author is unable and/or unwilling to defend it on LKML
>> ...
> 
> That's their fault, and definitely not a "very good reason" for making 
> life easier for them.

Putting aside the fruitless question of whose fault it is,
is it a "very good reason" for actively making life more
difficult for them than it is already, eg. by gratuitiously
breaking interfaces they rely on for no other "very good
reason" than to discourage out-of-tree development? In other
words, do you think it benefits the Linux community if you
discourage those programmers you've already scared away from
submitting their code to the kernel from continuing their
work off-tree, too? In summary, do you think the world would
be a better place if all the existing out-of-tree modules
just ceased to exist, without any replacement?

T.
