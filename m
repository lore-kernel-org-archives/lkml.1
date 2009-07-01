Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbZGAMH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbZGAMH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZGAMHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:07:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37106 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbZGAMHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:07:15 -0400
Message-ID: <4A4B5059.2000805@redhat.com>
Date: Wed, 01 Jul 2009 08:02:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][ PATCH] kprobes: fix kprobe selftest configuration	dependency
References: <20090622210302.4984.82798.stgit@localhost.localdomain> <20090630143806.9ab4519d.akpm@linux-foundation.org> <alpine.LFD.2.01.0906301440280.3605@localhost.localdomain> <4A4A8D91.8040009@redhat.com> <4A4A9D89.3090600@redhat.com> <20090630232359.GH17968@elte.hu> <4A4AA467.1010308@redhat.com> <4A4AA930.1060603@redhat.com> <20090701084304.GC8171@elte.hu>
In-Reply-To: <20090701084304.GC8171@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009年07月01日 04:43, Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Masami Hiramatsu wrote:
>>> Ingo Molnar wrote:
>>>> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
>>>>
>>>>> Oops, I couldn't reproduce this bug on the latest -tip tree.
>>>> maybe because i applied your fix already? ;-)
>>> If so, I'll be happy. But I reverted that change and checked :-(
>>> Maybe, that came from a combination of configs (but I've lost it...)
>> Ok, I found.
>> Sorry, the problem has been fixed with below commit...
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ac6ca5c86c63dd95acc6a34dff8d33c23b703a37
> 
> thx - i thus dropped this:
> 
>   130c5b2 kprobes: Fix kprobe selftest configuration dependency
> 
> Kept the other two patches - one for tracing/urgent (for .31), the 
> other for tracing/core (.32). Agreed?

Yes, I agreed. :-)

Thanks!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

