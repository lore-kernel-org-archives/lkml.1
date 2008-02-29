Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYB2RbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYB2RbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759300AbYB2Raz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:30:55 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756190AbYB2Ray (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:30:54 -0500
Date: Fri, 29 Feb 2008 09:29:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Michael Kerrisk <michael.kerrisk@googlemail.com>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
In-Reply-To: <1204305488.6243.113.camel@lappy>
Message-ID: <alpine.LFD.1.00.0802290928200.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>  <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>  <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>  <alpine.LFD.1.00.0802290907480.17889@woody.linux-foundation.org>
 <1204305488.6243.113.camel@lappy>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Peter Zijlstra wrote:
>
> > ... and what's the point? We've never had it before, nobody has ever cared, 
> > and the whole notion is just stupid. Why would we want to limit it? The 
> > only thing that the kernel *cares* about is the stack size - any other 
> > size limits are always going to be arbitrary.
> 
> Well, don't think of limiting it, but querying the limit.
> 
> Programs like xargs would need to know how much to stuff into argv
> before starting a new invocation.

But they already can't really do that. More importantly, isn't it better 
to just use the whole stack size then (or just return "stack size / 4" or 
whatever)?

			Linus
