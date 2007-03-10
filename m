Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXCJJGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXCJJGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbXCJJGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:06:36 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:57939 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbXCJJGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:06:34 -0500
Message-ID: <45F27503.1020108@vilain.net>
Date: Sat, 10 Mar 2007 22:06:11 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.4 (X11/20060615)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Matt Helsley <matthltc@us.ibm.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, pj@sgi.com,
       winget@google.com, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka	containers
 on top of nsproxy!
References: <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>	<45EF5A62.8000103@vilain.net>	<6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>	<45EF5E71.7090101@vilain.net>	<6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>	<45EF793C.1000700@vilain.net>	<6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com>	<45EF83CB.9080903@vilain.net>	<1173334209.13172.61.camel@localhost.localdomain>	<m11wk08c9h.fsf@ebiederm.dsl.xmission.com> <20070309010628.GE4506@MAIL.13thfloor.at>
In-Reply-To: <20070309010628.GE4506@MAIL.13thfloor.at>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Poetzl wrote:
> On Wed, Mar 07, 2007 at 11:44:58PM -0700, Eric W. Biederman wrote:
>   
>> I really don't much care as long as we don't start redefining
>> container as something else.  I think the IBM guys took it from
>> solaris originally which seems to define a zone as a set of
>> isolated processes (for us all separate namespaces).  And a container
>> as a set of as a zone that uses resource control.  Not exactly how
>> we have been using the term but close enough not to confuse someone.
>>
>> As long as we don't go calling the individual subsystems or the
>> process groups they need to function a container I really don't care.
>> [...]
>> Resource groups at least for subset of subsystems that aren't
>> namespaces sounds reasonable.  Heck resource group, resource
>> controller, resource subsystem, resource just about anything seems
>> sane to me.
>>
>> The important part is that we find a vocabulary without doubly
>> defined words so we can communicate and a small common set we can
>> agree on so people can work on and implement the individual
>> resource controllers/groups, and get the individual pieces merged
>> as they are reading.
>>     
>
> from my personal PoV the following would be fine:
>
>  spaces (for the various 'spaces')
>
>   - similar enough to the old namespace
>   - can be easily used with prefix/postfix
>     like in pid_space, mnt_space, uts_space etc
>   - AFAIK, it is not used yet for anything else
>
>  container (for resource accounting/limits)
>
>   - has the 'containment' principle built in :)
>   - is used in similar ways in other solutions
>   - sounds similar to context (easy to associate)
>
> note: I'm also fine with other names, as long as
> we find some useable vocabulary soon, [...]

I like these a lot, particularly in that "mount space" could be a
reasonable replacement for "namespace".

As a result of this discussion, I see the sense in Paul Menage's
original choice of term.

There's just one problem.  We'd have to rename the mailing list to
"spaces and containers" :-)

Sam.
