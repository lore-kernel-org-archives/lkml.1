Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZDUD2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZDUD2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 23:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZDUD2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 23:28:01 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54590 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbZDUD2A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 23:28:00 -0400
Date: Mon, 20 Apr 2009 23:26:38 -0400 (EDT)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Arjan van de Ven <arjan@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections
 -fdata-sections
In-Reply-To: <20090420201826.7c1f7f06@infradead.org>
Message-ID: <alpine.DEB.2.00.0904202318540.7725@vinegar-pot.mit.edu>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
 <alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain> <20090420201826.7c1f7f06@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009, Arjan van de Ven wrote:
> an alternative approach would be to have a special build target that
> uses this, but makes a 2nd vmlinux, and then runs a diff on the symbols
> against the regular one... and finds which functions got dropped.
> Some patient soul can then go about and stick in ifdefs and stuff...

We wouldn’t even need a 2nd vmlinux for that.  Once we can compile with 
-ffunction-sections -fdata-sections, we can just ask the linker to print 
the list of unused sections that it removed (--gc-sections 
--print-gc-sections).

Anders
