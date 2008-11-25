Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbYKYPz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbYKYPz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYKYPzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:55:06 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:16874 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbYKYPzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:55:04 -0500
Message-ID: <492C1FCB.1080405@openvz.org>
Date: Tue, 25 Nov 2008 18:54:51 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Kir Kolyshkin <kir@openvz.org>, linux-man@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documentation for CLONE_NEWPID
References: <4923810B.7010201@gmail.com> <492AA241.6050004@openvz.org> <cfd18e0f0811250746i711205dej6b98f2fba6cecc42@mail.gmail.com>
In-Reply-To: <cfd18e0f0811250746i711205dej6b98f2fba6cecc42@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +A PID namespace provides an isolated environment for PIDs:
>>> +PIDs in a new namespace start at 1,
>>> +somewhat like a standalone system, and calls to
>>> +.BR fork (2),
>>> +.BR vfork (2),
>>> +or
>>> +.BR clone (2)
>>> +will produce processes whose PIDs within the namespace
>>> +are only guaranteed to be unique within that namespace.
>> Well, I'm not sure I understood correctly what was meant here, but after
> 
> I've simplified that sentence somewhat.  Now it just reads:
> 
>               A  PID  namespace  provides  an isolated environment for
>               PIDs: PIDs in a new namespace start at 1, somewhat  like
>               a  standalone system, and calls to fork(2), vfork(2), or
>               clone(2) will  produce  processes  with  PIDs  that  are
>               unique within the namespace.

OK, thanks.

>> we have a namespace each task has two pids. And _all_ of them are unique
>> in corresponding namespaces.
> 
> And I already make that point lower down in the text (see ***), but
> now I extended the sentence there a little.
> 
> [...]
> 
> *** Here's where I make the point about each process having multiple PIDs"
> 
>>> +The existence of a namespace hierarchy means that each process
>>> +may now have multiple PIDs:
>>> +one for each namespace in which it is visible.
> 
> I added some words here:
> 
> "each of these PIDs is unique within the corresponding namespace".

Correct.

>>> +(A call to
>>> +.BR getpid (2)
>>> +always returns the PID associated with the namespace in which
>>> +the process was created.)
>> I don't thinks it's a good example - the getpid cannot be called
>> for other process other than current :)
> 
> It wasn't meant as an example.  The point was, with a process
> potentially being a member of multiple namespaces, the reader might
> wonder: what does getpid(2) return?  This sentence was intended to
> clarify that.  With that explanation, does this sentence now seem
> okay?

Yes, but I'd change "was created" into "lives in". From my POV this
sounds more clear. I do not insist however :)

> [...]
> 
> Cheers,
> 
> Michael
> 

