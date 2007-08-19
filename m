Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbXHSCJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbXHSCJc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 22:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbXHSCJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 22:09:24 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:40740
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbXHSCJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 22:09:23 -0400
Date: Sat, 18 Aug 2007 19:03:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan <alan@clueserver.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Marc Perkel <mperkel@yahoo.com>,
       Valdis.Kletnieks@vt.edu, Michael Tharp <gxti@partiallystapled.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
In-Reply-To: <1187479581.1608.1.camel@zowie.fnordora.org>
Message-ID: <Pine.LNX.4.64.0708181902460.22470@asgard.lang.hm>
References: <763705.7247.qm@web52512.mail.re2.yahoo.com> 
 <A631EFDE-354D-498E-980E-2B785517AC51@mac.com> <1187479581.1608.1.camel@zowie.fnordora.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2007, Alan wrote:

> On Wed, 2007-08-15 at 13:22 -0400, Kyle Moffett wrote:
>> On Aug 15, 2007, at 13:09:31, Marc Perkel wrote:
>>> The idea is that people have permissions - not files.  By people I
>>> mean users, groups, managers, applications
>>> etc. One might even specify that there are no permission
>>> restrictions at all. Part of the process would be that the kernel
>>> load what code it will use for the permission system. It might even
>>> be a little perl script you write.
>>>
>>> Also - you aren't even giving permission to access files. It's
>>> permission to access name patterns. One could apply REGEX masks to
>>> names to determine permissions. So if you have permission to the
>>> name you have permission to the file.
>>
>> Please excuse me, I'm going to go stand over in the corner for a minute.
>>
>> *hahahahahaa hahahahahaaa hahaa hoo hee snicker sniff*
>>
>> *wanders back into the conversation*
>>
>> Sorry about that, pardon me.
>>
>> I suspect you will find it somewhat hard to convince *anybody* on
>> this list to put either a regex engine or a Perl interpreter into the
>> kernel.  I doubt you could even get a simple shell-style pattern
>> matcher in.  First of all, both of the former chew up enormous gobs
>> of stack space *AND* they're NP-complete.  You just can't do such
>> matching even in polynomial time, let alone something that scales
>> appropriately for an OS kernel like, say, O(log(n)).
>
> Already been done.  Take a look at "AppArmor" aka "Immunix".

don't forget the ACPI interpreter.

David Lang
