Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZE0VsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZE0VsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZE0Vr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:47:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbZE0Vr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:47:57 -0400
Date: Wed, 27 May 2009 14:46:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
In-Reply-To: <20090527211828.GA6166@elte.hu>
Message-ID: <alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org> <1243409850-21577-18-git-send-email-jeremy@goop.org> <alpine.LFD.2.01.0905270829530.3435@localhost.localdomain> <20090527211828.GA6166@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 May 2009, Ingo Molnar wrote:
> 
> hm, i have to concur. Too often it ends up splitting attention away 
> from the title of the commit. I do reject (or fix up) bad impact 
> lines - will stop doing them altogether if you think there's a net 
> downside to them ...

I actually think that if there is a good reason for them, they can stay. 

Just don't make it one of those "every commit that goes through me has to 
have one".

Pu another way: if they actually add value in highlighting the commits 
that _should_ stand out, then hey, by all means, keep such ones. I would 
not at all object if it was an issue of 

 [ Impact: fix bugzilla entry 455123 ]

or

 [ Impact: fix user-triggerable oops ]

or something that actually matters, and that you _want_ to stand out, and 
that you may well _want_ to grep for.

It's when the whole series has them, and they don't add anything that 
isn't better said in the summary line, _that's_ what I dislike.

So to take the above bugzilla example: it really wouldn't be a good 
summary line (because the summary line should describe what the commit 
does, not point to some bugzilla entry), but at the same time it's clearly 
something that I do think we might want to automate the logs for.

IOW, that is something even I personally wouldn't mind adding to a commit, 
to help people like Rafael that track bugzilla. It makes sense as a 
special marker, even though it clearly _shoudln't_ be the summary. See?

Similarly, the "user-triggerable oops" might well be worth high-lighting 
in some manner. Now, the summary _might_ talk about it, but equally well 
the summary might be more specific in the actual implementation issue, and 
then perhaps the impact line is worth it.

But if all commits have them (at least for the x86-tip), then it's not a 
really highlight event any more, is it? At that point, anything it says is 
probably just as well described by the summary line - at least for any 
"regular" commits that aren't in some way worth the extra attention.

			Linus
