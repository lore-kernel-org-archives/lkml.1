Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbZDUKXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbZDUKXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZDUKXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:23:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37392 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZDUKXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:23:32 -0400
Date: Tue, 21 Apr 2009 12:26:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections -fdata-sections
Message-ID: <20090421102657.GA14687@one.firstfloor.org>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain> <alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain> <20090420201826.7c1f7f06@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420201826.7c1f7f06@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> we can probably drop a ton of ifdefs...

That would require always forcing it to on.

> an alternative approach would be to have a special build target that
> uses this, but makes a 2nd vmlinux, and then runs a diff on the symbols
> against the regular one... and finds which functions got dropped.
> Some patient soul can then go about and stick in ifdefs and stuff...

I bet that would result in horrible looking code. If the toolchain
based approach can be made to work (and from the reports of people
who tried it it sounds like it can) that would be vastly preferable.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
