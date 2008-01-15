Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYAOSxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYAOSxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYAOSxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:53:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170AbYAOSxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:53:30 -0500
Date: Tue, 15 Jan 2008 10:52:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [2.6.24 patch] restore ARMv6 OProfile support
In-Reply-To: <20080115173701.GB8375@Krystal>
Message-ID: <alpine.LFD.1.00.0801151051120.2806@woody.linux-foundation.org>
References: <20071228195841.GA3945@flint.arm.linux.org.uk> <20080115104526.GA32067@flint.arm.linux.org.uk> <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org> <20080115173701.GB8375@Krystal>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jan 2008, Mathieu Desnoyers wrote:
> 
> Well, it goes along the lines of the patch I suggested as a reply to
> Adrian, with these differences :
> 
> - I still source the kernel/Kconfig.instrumentation file.
> - I put back the missing OPROFILE options directly in arch/arm/Kconfig
> 
> Then end result is the same as your patch, but without the code
> duplication.

No it's not.

Now the config variables may all be there, but the UI for the *menu* 
system is broken (ie all the ARM profiling config options are now outside 
the profiling menu).

Is that menu really needed? I dunno. But since it exists, it should be 
correct.

		Linus
