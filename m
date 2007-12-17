Return-Path: <linux-kernel-owner+w=401wt.eu-S935880AbXLQQU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935880AbXLQQU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935537AbXLQQUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:20:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935031AbXLQQUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:20:35 -0500
Message-ID: <4766A199.70504@redhat.com>
Date: Mon, 17 Dec 2007 11:19:37 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: Final kprobes rollup patches
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu> <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu> <4766841B.1040500@redhat.com> <20071217143050.GA13290@elte.hu> <476695D9.8090904@redhat.com> <20071217160659.GC30958@elte.hu>
In-Reply-To: <20071217160659.GC30958@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>>> cool! Please Cc: lkml and Harvey as well so that there's less 
>>> overlap in unification work - Harvey spent quite some time unifying 
>>> and cleaning up the kprobes code during the past week.
>> Should I rewrite it based on current git tree?
>> My patch includes 3 part of patches.
>> - 2 Bugfix patches (which is not merged yet.)
>> - 2 booster patches (ditto)
>> - 2 unification patches (most of this patches are already done by Harvey's patch)
> 
> would it be easier/more robust to first did the unification patches and 
> then get the bugfixes and new features in? That would give us your 
> bugfixes and new features on both 32-bit and 64-bit at the same time.

As far as I can see, my patches have less #ifdefs than Harvey's.
However, that patch's granularity may be not so good currently.

> feel free to do whichever approach you prefer - but it would be nice to 
> preserve the unification and cleanup work done by Harvey.

OK, rewriting will take a while, so I sent a series of patches which I have just now.

> btw., is any of your bugfixes 2.6.24 material?

Yes, I'd like to fix first two bugs in 2.6.24.

Thank you very much,

> 
> 	Ingo

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

