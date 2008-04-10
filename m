Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbYDJVgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbYDJVgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 17:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbYDJVfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 17:35:50 -0400
Received: from khc.piap.pl ([195.187.100.11]:40758 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbYDJVft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 17:35:49 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>,
       jeff@garzik.org, matthew@wil.cx, auke-jan.h.kok@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, linux-pci@atrey.karlin.mff.cuni.cz,
       akpm@linux-foundation.org, davem@davemloft.net,
       jesse.brandeburg@intel.com, john.ronciak@intel.com,
       bruce.w.allan@intel.com, greg@kroah.com, arjan@linux.intel.com,
       rjw@sisk.pl
Subject: Re: [patch] e1000=y && e1000e=m regression fix (was: Re: [regression] e1000e broke e1000)
References: <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com>
	<20080408183921.GA20803@elte.hu>
	<20080408193245.GG11962@parisc-linux.org>
	<20080408195123.GA28148@elte.hu> <47FBCE00.2020309@garzik.org>
	<20080408200652.GC28148@elte.hu> <47FBD34A.6080508@garzik.org>
	<20080408203314.GA28952@elte.hu> <47FBDBE9.9040700@garzik.org>
	<47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu>
	<200804092249.23111.elendil@planet.nl>
	<m363uqwpds.fsf@maximus.localdomain>
	<alpine.LFD.1.00.0804091838330.3143@woody.linux-foundation.org>
	<m34paaav7o.fsf@maximus.localdomain>
	<alpine.LFD.1.00.0804100724220.3143@woody.linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 10 Apr 2008 23:35:37 +0200
In-Reply-To: <alpine.LFD.1.00.0804100724220.3143@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 10 Apr 2008 07\:30\:34 -0700 \(PDT\)")
Message-ID: <m3prsxpf4m.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> No it wouldn't, not when the driver we used forever suddenly stopped 
> supporting them.

In this case e1000 stops supporting them only if you enable e1000e
too. No e1000e, e1000 still does those IDs. For now, if I understand
it correctly. And it seems to print a warning.

So it doesn't work if you make e1000e a module and don't load it.

> And no, I'm not talking about some theoretical "this could happen" thing. 
> I hit exactly that with commit
> 040babf9d84e7010c457e9ce69e9eb1c27927c9e 

Right. Now it's a different situation, though.
-- 
Krzysztof Halasa
