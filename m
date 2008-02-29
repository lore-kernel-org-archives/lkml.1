Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbYB2RhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbYB2RhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYB2RhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:37:04 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbYB2RhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:37:02 -0500
Date: Fri, 29 Feb 2008 09:35:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Michael Kerrisk <michael.kerrisk@googlemail.com>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
In-Reply-To: <1204305244.6243.111.camel@lappy>
Message-ID: <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>  <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>  <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com> <1204305244.6243.111.camel@lappy>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Peter Zijlstra wrote:
> 
> You fail to mention that <23 will still fault the first time it tries to
> grow the stack when you set rlimit_stack to 128k and actually supply
> 128k of env+arg.

So? That's what rlimit_stack has always meant (and not just on Linux 
either, afaik). That's not a bug, it's a feature. If the system has a 
limited stack, it has a limited stack. That's what RLIMIT_STACK means.

		Linus
