Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbZBFQET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbZBFQET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZBFQED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:04:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34625 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZBFQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:04:00 -0500
Date: Fri, 6 Feb 2009 16:02:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       cooloney@kernel.org, ralf@linux-mips.org, dhowells@redhat.com,
       matthew@wil.cx, chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090206160200.GG13758@n2100.arm.linux.org.uk>
References: <20090205191907.GA27422@elte.hu> <1233886017.3463.26.camel@localhost.localdomain> <20090206022025.GA8317@elte.hu> <1233929922.3209.6.camel@localhost.localdomain> <20090206142134.GA13758@n2100.arm.linux.org.uk> <1233930860.3209.13.camel@localhost.localdomain> <20090206145119.GB13758@n2100.arm.linux.org.uk> <1233932407.3209.18.camel@localhost.localdomain> <20090206151027.GC13758@n2100.arm.linux.org.uk> <20090206155624.GR18368@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206155624.GR18368@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 04:56:24PM +0100, Ingo Molnar wrote:
> 
> * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > Taking this further, if you're including linux/types.h into another
> > header file, you're including it because you want some C type from
> > that or an included file.  Use of that type is also not ASM friendly,
> > so the use is going to have to be excluded by ifndef in that header.
> 
> There's a ton of header files that can be included in assembly code and 
> which also contain C declarations and definitions. This is achieved by 
> adding a:
> 
>  #ifndef __ASSEMBLY__
>  #endif
> 
> Blocks around the C code. Especially for smallish or single-purpose files 
> this is often a cleaner method than splitting the file.

Err, yes, thank you for justifying my point.

And no, I didn't say anything about splitting files.  Not sure why you
brought that up.
