Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbYB2SP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbYB2SP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYB2SPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:15:16 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbYB2SPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:15:14 -0500
Date: Fri, 29 Feb 2008 10:14:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Michael Kerrisk <michael.kerrisk@googlemail.com>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
In-Reply-To: <1204307756.6243.121.camel@lappy>
Message-ID: <alpine.LFD.1.00.0802291013090.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>  <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>  <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>  <1204305244.6243.111.camel@lappy>  <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>
 <1204307756.6243.121.camel@lappy>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Peter Zijlstra wrote:
> 
> Well, I agree with that point. It just that apparently POSIX does not.
> According to Michael POSIX does not consider the arg+env array part of
> the stack proper.

I don't think that's true.

POSIX has always been guided on "what you can depend on", not "we make up 
new features". And if that has changed, then it's a problem for POSIX, not 
for Linux.

IOW, I think somebody is either reading the standard wrong, or the 
standard is not worth reading.

		Linus
