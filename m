Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbXLSCaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbXLSCaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 21:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXLSCaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 21:30:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:45078 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXLSCaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 21:30:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nMkqamKv0CmJzdvwa84MlHpXKwSxG2mEFT0ewJ3j948hExa6Mc5S6YmEV22VrPkH9Adf/UB1Vm5gxsEktccNI6eG1rBTZQy6Fbz7Xxi8pbR47hmPr292HDiFVdZttDANB2f/2I3MckxHHQTjjTeql3mYkDIWrsAV9QgBH07pS5E=
Subject: Re: [PATCH 3/4] x86: add kprobe-booster to X86_64
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4767D02C.6030704@redhat.com>
References: <1197930464.23402.112.camel@brick>
	 <20071218112936.GE9002@elte.hu> <1197978160.7734.31.camel@brick>
	 <4767D02C.6030704@redhat.com>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 18:30:00 -0800
Message-Id: <1198031400.7734.41.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-18 at 08:50 -0500, Masami Hiramatsu wrote:
> Hi Harvey,
> 
> Thank you for cleaning this up.
> 
> Harvey Harrison wrote:
> > Subject: [PATCH] x86: kprobes leftover cleanups
> > 
> > Eliminate __always_inline, all of these static functions are
> > only called once.  Minor whitespace cleanup.  Eliminate one
> > supefluous return at end of void function.  Reverse sense of
> > #ifndef to be #ifdef to show the case only affects X86_32.
> 
> Unfortunately, to prevent kprobe recursive call, all functions which
> is called from kprobes must be inlined or have __kprobes.
> If __always_inline macro still work, I prefer to use it. If not,
> it must have a __kprobe attribute like as below.

I thought all static functions that were only called once were
automatically inlined these days?  Otherwise __always_inline and
inline are exactly the same in the kernel.

Harvey

