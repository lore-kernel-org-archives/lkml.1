Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbXCHAf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbXCHAf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXCHAf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:35:57 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:50011 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXCHAfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:35:55 -0500
Message-ID: <45EF5A62.8000103@vilain.net>
Date: Thu, 08 Mar 2007 13:35:46 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.2 (X11/20060521)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, akpm@linux-foundation.org,
       pj@sgi.com, dev@sw.ru, xemul@sw.ru, containers@lists.osdl.org,
       winget@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
 top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>	 <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>	 <20070307173031.GC2336@in.ibm.com>	 <20070307174346.GA19521@sergelap.austin.ibm.com>	 <20070307180055.GC17151@in.ibm.com>	 <20070307205846.GB7010@sergelap.austin.ibm.com>	 <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>	 <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com> <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
In-Reply-To: <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
>> In the namespace world when we say container we mean roughly at the level
>> of nsproxy and container_group.
>>     
> So you're saying that a task can only be in a single system-wide container.
>   

Nope, we didn't make the mistake of nailing down what a "container" was
too far before it is implemented.  We talked before about
containers-within-containers because, inevitably if you provide a
feature you'll end up having to deal with virtualising systems that in
turn use that feature.

> My patch provides multiple potentially-independent ways of dividing up
> the tasks on the system - if the "container" is the set of all
> divisions that the process is in, what's an appropriate term for the
> sub-units?
>   

namespace, since 2.4.x

> That assumes the viewpoint that your terminology is "correct" and
> other people's needs "fixing". :-)
>   

Absolutely.  Please respect the semantics established so far; changing
them adds nothing at the cost of much confusion.

> But as I've said I'm not particularly wedded to the term "container"
> if that really turned out to be what's blocking acceptance from people
> like Andrew or Linus. Do you have a suggestion for a better name? To
> me, "process container" seems like the ideal name, since it's an
> abstraction that "contains" processes and associates them with some
> (subsystem-provided) state.
>   

It's not even really the term, it's the semantics.

Sam.
