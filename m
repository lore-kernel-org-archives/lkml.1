Return-Path: <linux-kernel-owner+w=401wt.eu-S2992683AbXCGWfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992683AbXCGWfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992680AbXCGWfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:35:04 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58750 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992683AbXCGWfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:35:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Paul Menage" <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, sam@vilain.net,
       akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru, xemul@sw.ru,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>
	<6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
	<20070307173031.GC2336@in.ibm.com>
	<20070307174346.GA19521@sergelap.austin.ibm.com>
	<20070307180055.GC17151@in.ibm.com>
	<20070307205846.GB7010@sergelap.austin.ibm.com>
	<6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
Date: Wed, 07 Mar 2007 15:32:48 -0700
In-Reply-To: <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	(Paul Menage's message of "Wed, 7 Mar 2007 13:20:18 -0800")
Message-ID: <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul Menage" <menage@google.com> writes:

> On 3/7/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
>>
>> All that being said, if it were going to save space without overly
>> complicating things I'm actually not opposed to using nsproxy, but it
>
> If space-saving is the main issue, then the latest version of my
> containers patches uses just a single pointer in the task_struct, and
> all tasks in the same set of containers (across all hierarchies) will
> share a single container_group object, which holds the actual pointers
> to container state.

Yes.

However:
> Effectively, container_group is to container as nsproxy is to namespace.

The statement above nicely summarizes the confusion in terminology.

In the namespace world when we say container we mean roughly at the level
of nsproxy and container_group.  Although it is expected to be a user space
concept like an application, not a concept implemented directly in the kernel.
i.e. User space is expected to combine separate resource controls and namespaces
and run processes inside that combination.

You are calling something that is on par with a namespace a container.  Which
seriously muddies the waters.  About as much as calling as referring to your
shoe as your whole outfit.

Without fixing the terminology it is going to be very hard to
successfully communicate.

Eric

