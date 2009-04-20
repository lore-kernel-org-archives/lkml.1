Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZDTXtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZDTXtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZDTXs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:48:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304AbZDTXs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:48:58 -0400
Date: Mon, 20 Apr 2009 16:40:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tim Abbott <tabbott@MIT.EDU>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections
 -fdata-sections
In-Reply-To: <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu>
Message-ID: <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Apr 2009, Tim Abbott wrote:
>
> Is there a problem that is preventing this -ffunction-sections patch 
> series from being merged?

Quite frankly, every time I see something like this, I shudder.

Why?

The bugs in the toolchains tend to be infinite and _really_ annoying. 
We'll end up with everything from "gcc-xyz cannot handle it" to 
"binutils-abc which was pre-released by RH/Ubuntu/SUSE will SIGSEGV". 

And those are the _good_ cases. The bad cases are just silently 
miscompiled/linked stuff under certain circumstances.

In other words, I'm not going to merge it without a _lot_ of people 
pushing me on it with nice numbers etc. Because I absolutely hate the 
tools issues that I'm convinced will happen the moment I merge it.

		Linus
