Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbXCHAm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbXCHAm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXCHAm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:42:26 -0500
Received: from smtp-out.google.com ([216.239.33.17]:59361 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbXCHAmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:42:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vCKKInvFjU8NAZH9mjxiTh2s8HVa5sF2kf0rF6wGCQjt319cxb9FZWbSilGsEyMbi
	CmuBiBpRkgPzP4kZSbxcA==
Message-ID: <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
Date: Wed, 7 Mar 2007 16:42:05 -0800
From: "Paul Menage" <menage@google.com>
To: "Sam Vilain" <sam@vilain.net>
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, akpm@linux-foundation.org,
       pj@sgi.com, dev@sw.ru, xemul@sw.ru, containers@lists.osdl.org,
       winget@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <45EF5A62.8000103@vilain.net>
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
	 <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	 <45EF5A62.8000103@vilain.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Sam Vilain <sam@vilain.net> wrote:
> Paul Menage wrote:
> >> In the namespace world when we say container we mean roughly at the level
> >> of nsproxy and container_group.
> >>
> > So you're saying that a task can only be in a single system-wide container.
> >
>
> Nope, we didn't make the mistake of nailing down what a "container" was
> too far before it is implemented.  We talked before about
> containers-within-containers because, inevitably if you provide a
> feature you'll end up having to deal with virtualising systems that in
> turn use that feature.

Sure, my aproach allows containers hierarchically as children of other
containers too.

>
> > My patch provides multiple potentially-independent ways of dividing up
> > the tasks on the system - if the "container" is the set of all
> > divisions that the process is in, what's an appropriate term for the
> > sub-units?
> >
>
> namespace, since 2.4.x
>
> > That assumes the viewpoint that your terminology is "correct" and
> > other people's needs "fixing". :-)
> >
>
> Absolutely.  Please respect the semantics established so far; changing
> them adds nothing at the cost of much confusion.

But "namespace" has well-established historical semantics too - a way
of changing the mappings of local names to global objects. This
doesn't describe things liek resource controllers, cpusets, resource
monitoring, etc.

Trying to extend the well-known term namespace to refer to things that
aren't namespaces isn't a useful approach, IMO.

Paul
