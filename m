Return-Path: <linux-kernel-owner+w=401wt.eu-S965714AbXCGXSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965714AbXCGXSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965725AbXCGXSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:18:40 -0500
Received: from smtp-out.google.com ([216.239.45.13]:13272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965714AbXCGXSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:18:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=rpIaX+CBJN0Lj2oly0NONvgh4OAWR/rFNGRmM0y9ZWLd2Ud7i3gMNXOotwshz2ZeG
	lvVufSCWgF8ady783BPTg==
Message-ID: <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
Date: Wed, 7 Mar 2007 15:18:25 -0800
From: "Paul Menage" <menage@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, sam@vilain.net,
       akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru, xemul@sw.ru,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301133543.GK15509@in.ibm.com>
	 <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
	 <20070307173031.GC2336@in.ibm.com>
	 <20070307174346.GA19521@sergelap.austin.ibm.com>
	 <20070307180055.GC17151@in.ibm.com>
	 <20070307205846.GB7010@sergelap.austin.ibm.com>
	 <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	 <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Effectively, container_group is to container as nsproxy is to namespace.
>
> The statement above nicely summarizes the confusion in terminology.
>
> In the namespace world when we say container we mean roughly at the level
> of nsproxy and container_group.

So you're saying that a task can only be in a single system-wide container.

My patch provides multiple potentially-independent ways of dividing up
the tasks on the system - if the "container" is the set of all
divisions that the process is in, what's an appropriate term for the
sub-units?

>
> You are calling something that is on par with a namespace a container.

Yes.

> Which
> seriously muddies the waters.  About as much as calling as referring to your
> shoe as your whole outfit.
> Without fixing the terminology it is going to be very hard to
> successfully communicate.

That assumes the viewpoint that your terminology is "correct" and
other people's needs "fixing". :-)

But as I've said I'm not particularly wedded to the term "container"
if that really turned out to be what's blocking acceptance from people
like Andrew or Linus. Do you have a suggestion for a better name? To
me, "process container" seems like the ideal name, since it's an
abstraction that "contains" processes and associates them with some
(subsystem-provided) state.

Paul
