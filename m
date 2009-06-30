Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbZF3XRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbZF3XRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZF3XRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:17:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54628 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbZF3XRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:17:16 -0400
Message-ID: <4A4A9D89.3090600@redhat.com>
Date: Tue, 30 Jun 2009 19:19:37 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
CC: ananth@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][ PATCH] kprobes: fix kprobe selftest configuration dependency
References: <20090622210302.4984.82798.stgit@localhost.localdomain> <20090630143806.9ab4519d.akpm@linux-foundation.org> <alpine.LFD.2.01.0906301440280.3605@localhost.localdomain> <4A4A8D91.8040009@redhat.com>
In-Reply-To: <4A4A8D91.8040009@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, I couldn't reproduce this bug on the latest -tip tree.
I'll need to dig it deeper. Andew, and Ingo, could you please drop it?

Masami Hiramatsu wrote:
> Linus Torvalds wrote:
>> On Tue, 30 Jun 2009, Andrew Morton wrote:
>>> Still, the end result is significently more complex and fragile than a
>>> `depends on' would have been.  But I suppose we've done worse.  Oh well.
>> Couldn't we just limit the selftest to a set of symbols that doesn't 
>> require the "all" part?
> 
> OK. I'll try it.
> 
> Thank you,
> 
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

