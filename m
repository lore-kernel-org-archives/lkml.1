Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZJGWe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZJGWe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZJGWe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:34:28 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:43059 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZJGWe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:34:27 -0400
Date: Wed, 07 Oct 2009 18:33:28 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-reply-to: <alpine.LFD.2.01.0910061059100.3432@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0910071348430.13522@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu>
 <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
 <20091006153632.GA29795@elte.hu>
 <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain>
 <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
 <alpine.LFD.2.00.0910061311460.7229@localhost.localdomain>
 <alpine.LFD.2.01.0910061059100.3432@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ... please just turn on CONFIG_LOCALCONFIG_AUTO

For git-tree-based builds, I'm delighted with CONFIG_LOCALCONFIG_AUTO.

But on my build engine, I don't need or want the exact commit id.
(I have a descriptive originating branch name for it already,
and that is a heck of a lot easier to understand)

Indeed SUBLEVEL and EXTRAVERSION in the Makefile turn out to be
just about ideal both for good .config file library re-use,
and with double buffering, storing of results.

So if the -rc* EXTRAVERSION naming scheme were applied consistently
so that it could differentiate between a final release and
the following merge window, then SUBLEVEL and EXTRAVERSION
would be all I need on my build box.

Re: scripts to generate .scmversion

I'll pass.

I'd rather a script to simply update SUBLEVEL and EXTRAVERSION
in the Makefile upon seeing the 1st commit of the merge window.
I was hoping you'd do that for me, but failing that,
I can do it for myself.  Just don't jump on me when I call
the merge window rc0.

thanks,
-Len
