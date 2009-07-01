Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbZGAAHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbZGAAHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZGAAG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:06:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44249 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbZGAAG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:06:57 -0400
Message-ID: <4A4AA930.1060603@redhat.com>
Date: Tue, 30 Jun 2009 20:09:20 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][ PATCH] kprobes: fix kprobe selftest configuration	dependency
References: <20090622210302.4984.82798.stgit@localhost.localdomain> <20090630143806.9ab4519d.akpm@linux-foundation.org> <alpine.LFD.2.01.0906301440280.3605@localhost.localdomain> <4A4A8D91.8040009@redhat.com> <4A4A9D89.3090600@redhat.com> <20090630232359.GH17968@elte.hu> <4A4AA467.1010308@redhat.com>
In-Reply-To: <4A4AA467.1010308@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Ingo Molnar wrote:
>> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
>>
>>> Oops, I couldn't reproduce this bug on the latest -tip tree.
>> maybe because i applied your fix already? ;-)
> 
> If so, I'll be happy. But I reverted that change and checked :-(
> Maybe, that came from a combination of configs (but I've lost it...)

Ok, I found.
Sorry, the problem has been fixed with below commit...

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ac6ca5c86c63dd95acc6a34dff8d33c23b703a37

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

