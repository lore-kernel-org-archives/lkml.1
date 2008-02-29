Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbYB2QGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbYB2QGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759866AbYB2QGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:06:13 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758687AbYB2QGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:06:12 -0500
Date: Fri, 29 Feb 2008 08:05:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: aaw <aaw@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       michael.kerrisk@gmail.com, carlos@codesourcery.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
In-Reply-To: <1204119455.6242.403.camel@lappy>
Message-ID: <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Feb 2008, Peter Zijlstra wrote:
> 
> Currently these arrays are considered part of the stack, and
> RLIMIT_STACK includes them. However POSIX does not specify it must be
> so.

What's the real advantage of this? I'm not seeing it. Just an extra 
complexity "niceness" that nobody can rely on anyway since it's not even 
specified, and older kernels won't do it.

		Linus
