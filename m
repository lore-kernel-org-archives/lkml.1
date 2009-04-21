Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZDUAnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZDUAnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 20:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZDUAna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 20:43:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813AbZDUAn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 20:43:29 -0400
Date: Mon, 20 Apr 2009 17:35:32 -0700 (PDT)
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
In-Reply-To: <alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu>
Message-ID: <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
 <alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Apr 2009, Tim Abbott wrote:
> 
> I assume you're only worried about toolchain problems for people who are 
> actually using the -ffunction-sections option.  Would it help if the 
> -ffunction-sections compilation option were marked as experimental until 
> proven otherwise?

The thing is, people will enable them, and then maybe the compiler 
_appears_ to work, and things don't boot, and people spend tons of time 
chasing down somethign that just turns out to be a tools issue and not a 
kernel issue at all. And nobody happens to realize that what's up is that 
the person who reported the regression had enabled an experimental 
feature.

> If you're not willing to merge even an experimental option for 
> -ffunction-sections, would you at least be willing to merge the first 
> three patches in the patch series?  Compiling with -ffunction-sections 
> would not be supported by the mainline kernel, so any toolchain issues 
> with it would not be your problem.  But any vendor that wants to take 
> advantage of -ffunction-sections would still be able to use it without 
> having to maintain 300 lines of scattered changes to the kernel.

Are there any advantages outside of the size things?

Do we end up packing data better? 

I'd like to have some more champions of this code, in other words.

I'd be ok with merging it, but I haven't really gotten a strong feeling 
that anybody is going to enable it or use it.

			Linus
