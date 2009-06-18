Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbZFRWmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbZFRWmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZFRWmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:42:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:52428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZFRWmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:42:16 -0400
Message-ID: <4A3AC327.8020500@kernel.org>
Date: Fri, 19 Jun 2009 07:43:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca
Subject: Re: [GIT PULL] percpu for 2.6.31
References: <4A39F5B4.1070305@kernel.org>	<alpine.LFD.2.01.0906181421460.16802@localhost.localdomain> <20090618143959.62858ef6.akpm@linux-foundation.org>
In-Reply-To: <20090618143959.62858ef6.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 22:42:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

Andrew Morton wrote:
> On Thu, 18 Jun 2009 14:22:20 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Thu, 18 Jun 2009, Tejun Heo wrote:
>>> Please pull from percpu-for-linus git tree from:
>>>
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus
>> I'm very unhappy with this kind of crap.
> 
> AFACIT none of these patches have ever been in linux-next.  Half or
> more of them turned up on the mailing list for the first time two days
> ago and there's little evidence that anyone has even looked at them.

Unfortunately, they grew out of their home so they didn't have proper
path to linux-next but I wasn't that careless.  The two patchsets went
through three and four revisions.

percpu-convert-most-archs-to-dynamic-percpu

    http://thread.gmane.org/gmane.linux.kernel.cross-arch/3818
    http://www.gossamer-threads.com/lists/linux/kernel/1083895
    http://thread.gmane.org/gmane.linux.kernel/839059

x86-percpu-fix-pageattr-handling

    http://thread.gmane.org/gmane.linux.kernel.cross-arch/3825
    http://thread.gmane.org/gmane.linux.kernel/844298
    http://article.gmane.org/gmane.linux.kernel/837157
    http://thread.gmane.org/gmane.linux.kernel/836771

> If this doesn't mean "you missed 2.6.31" then what does?
> 
> Yes, things like this can be messy and hard to develop and maintain
> outside the merge window.  We understand this.  There are special
> cases.  But when this happens, let's talk about it and see what we can
> do!  Please let's not pretend that this is an ordinary old git merge
> like all the others.

Sorry.  My fault.  It used to go through x86 and this was me realizing
that nobody was gonna take care of these patchsets and prepping trees
myself in a hurry.  Won't happen again.

Thanks.

-- 
tejun
