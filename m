Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbYB2R41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbYB2R41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbYB2R4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:56:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34343 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbYB2R4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:56:19 -0500
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Kerrisk <michael.kerrisk@googlemail.com>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
In-Reply-To: <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>
	 <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>
	 <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
	 <1204305244.6243.111.camel@lappy>
	 <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 18:55:56 +0100
Message-Id: <1204307756.6243.121.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 09:35 -0800, Linus Torvalds wrote:
> 
> On Fri, 29 Feb 2008, Peter Zijlstra wrote:
> > 
> > You fail to mention that <23 will still fault the first time it tries to
> > grow the stack when you set rlimit_stack to 128k and actually supply
> > 128k of env+arg.
> 
> So? That's what rlimit_stack has always meant (and not just on Linux 
> either, afaik). That's not a bug, it's a feature. If the system has a 
> limited stack, it has a limited stack. That's what RLIMIT_STACK means.

Well, I agree with that point. It just that apparently POSIX does not.
According to Michael POSIX does not consider the arg+env array part of
the stack proper.



