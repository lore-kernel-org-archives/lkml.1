Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbYDLIrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbYDLIrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 04:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbYDLIrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 04:47:21 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:53264 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbYDLIrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:47:19 -0400
Date: Sat, 12 Apr 2008 10:41:44 +0200
Message-Id: <236089132@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: tilman@imap.cc
Subject: Re: 2.6.25-rc8: FTP transfer errors
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18gwSBOY1TDf+q9s+4ozswYIHeTN0TAB1FbKJ65zLNPAMhHo
 mGoofhHjAG7HfAHEp4IHSoJqXaMsDTe3Y5Bqqt8k5dn4EhVjlU=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Sure. It's not about bisection specifically, but about the time a
>reporter is able to invest in addition to what went into the report
>already. But bisection is is a good example, because it's the most
>time-consuming of all the tasks routinely asked from bug reporters.

i think the problem with git-bisect is, that it just apears complicated and magic for an end-user. 
this isn`t something a kernel-developer can explain to him in a sentence (i.e. how to use etc)

at short:  i think this scares non-developers (=end users) away.
git is for developers, not for end-users.

it`s up to the user to get into that and that`s something a user probably doesn`t dare and also doesn`t want.
he has a bug and want`s this resolved. 
it`s very valuable if he reported the problem on lkml at all (many users just don`t care, many just don't dare posting mails reaching that big audience), but it would be really BAD if nothing more happens just because the user isn`t willing to spend an evening or more to dig into a bug being introduced by some commit months ago.

it`s that sort of "it worked for me for years and now it doesn`t work anymore. please make it work as before".

you know that ibm virtualization ad (the heist) from years ago?  
it`s also that "how do i know? you´ re the cops!" - thing.

what about making it more trivial for non-developers by providing a type of "dummy's interface to git bisect" ?

some "please use the script which helps you find the change that may introduced the bug by binary search” at  /usr/src/linux/scripts...."

maybe it could look like this:

1. you don`t have git on this box. please install git (see http://.....)
2. what was the last known kernel version which worked for you ? 
3. what was the first kernel version which showed the problem you reported ?
<now git bisect machinery runs behind the scene and the user doesn`t need to learn git/bisect at all>
4. now please try this kernel build
<test>
5. did it work for you (y/n)
.....

many software companies have some type of support-script for their software, to make it easy to collect all the important data - so maybe it would give a sense to make it easier for the end-user to use git-bisect ?

regards
roland

ps:
good article on this, btw:
http://www.linuxworld.com/news/2007/112007-kernel.html?page=3




On Sat, 12 Apr 2008 02:25:36 +0400, Evgeniy Polyakov wrote:
> On Sat, Apr 12, 2008 at 12:16:28AM +0200, Tilman Schmidt (tilman@imap.cc) wrote:
>> So I was right after all? Bug reports from people who (for whatever
>> reason, including having to earn their living) cannot do a bisect are
>> not welcome?
> 
> You got it wrong.

Did I really? Let's see ...

> If bug is subtle and developers can not reproduce it, there are only two
> ways out of the problem: to help developers or not to help.
> 
> In the latter case bug report is useless (except that to show that it
> exists, since practically no one can fix it until some new details
> added).

Looks like you're saying I was right after all. Useless bug reports
shouldn't be submitted.

So please answer this simple question: If I know beforehand that I won't
have the time to do a bisect (or other similarly time-consuming task the
maintainers might ask from me), should I report the bug, or should I
keep my knowledge to myself?

This question is not theoretical. It's a situation I find myself in
quite regularly, because I allow myself the luxury of building most rc
kernels and even the odd mm kernel just for fun even though I have a
daytime job and a family to feed. It would be quite easy to look the
other way if I encounter a problem in one of those, hoping someone else
with more time on his or her hands will also come across it and report
it. So far my conscience told me not to do that. But if reporting it
without being able to follow up on it is considered useless then my
conscience was apparently wrong. Just say the word, and I'll stop what
I'm doing. I'll have no problem finding other things to do with my time.

> Bisection was just an example of the help, reporter can provide.

Sure. It's not about bisection specifically, but about the time a
reporter is able to invest in addition to what went into the report
already. But bisection is is a good example, because it's the most
time-consuming of all the tasks routinely asked from bug reporters.

> If you can not proceed with what was suggested, then do
> not piss anyone off because you were told to do something to help.

If a polite "sorry, I don't have the time" already counts as pissing
off, the only choice left is to avoid the situation in which I'd have to
say that. IOW, don't report bugs if I don't have the time to follow
through. Again: if that is what you want, I have no problem with it.

> If you go to the doctor because of aching throat and he asks you to
> open a mouth, you will not blame him for asking you to do that.

That analogy is wrong on so many accounts. It is not my throat that's
aching. A doctor would not insult me for not wanting to open my mouth
but rather ask if there was perhaps a valid reason for that. Not to
mention that opening my mouth takes substantially less time than a Linux
kernel bisection ...

A better analogy would be if I see an object lying on the highway, and I
stop at the next service area to call the police and alert them about
the possible danger. If they'd ask me to drive back to the place where I
saw it in order to describe precisely where it lay and what it looked
like, I think I might indeed become a bit upset.

HTH
T.

PS: I'll shut my big mouth now. The topic has been beaten to death.
__________________________________________________
GRATIS: Movie-FLAT. Jetzt freischalten!
http://freemail.web.de/club/maxdome.htm/?mc=025557

