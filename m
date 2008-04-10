Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYDJRz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYDJRz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbYDJRzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:55:19 -0400
Received: from colo.lackof.org ([198.49.126.79]:43416 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089AbYDJRzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:55:17 -0400
Date: Thu, 10 Apr 2008 11:55:03 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Frans Pop <elendil@planet.nl>,
       Ingo Molnar <mingo@elte.hu>, jeff@garzik.org, matthew@wil.cx,
       auke-jan.h.kok@intel.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       linux-pci@atrey.karlin.mff.cuni.cz, akpm@linux-foundation.org,
       davem@davemloft.net, jesse.brandeburg@intel.com, john.ronciak@intel.com,
       bruce.w.allan@intel.com, greg@kroah.com, arjan@linux.intel.com,
       rjw@sisk.pl
Subject: Re: [patch] e1000=y && e1000e=m regression fix (was: Re:
	[regression] e1000e broke e1000)
Message-ID: <20080410175503.GA11440@colo.lackof.org>
References: <47FBD34A.6080508@garzik.org> <20080408203314.GA28952@elte.hu> <47FBDBE9.9040700@garzik.org> <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <200804092249.23111.elendil@planet.nl> <m363uqwpds.fsf@maximus.localdomain> <alpine.LFD.1.00.0804091838330.3143@woody.linux-foundation.org> <m34paaav7o.fsf@maximus.localdomain> <alpine.LFD.1.00.0804100724220.3143@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804100724220.3143@woody.linux-foundation.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 07:30:34AM -0700, Linus Torvalds wrote:
...
> The fact that some *other* driver that I'd never ever enabled in my life 
> suddenly supports them is irrelevant - it's not in my list of "hardware I 
> have", and it's not even getting compiled.

If e1000e is not getting compiled, my understanding was the original e1000
driver will claim whatever devices it historically has.

> And no, I'm not talking about some theoretical "this could happen" thing. 
> I hit exactly that with commit 040babf9d84e7010c457e9ce69e9eb1c27927c9e (I 
> then thought that the new driver didn't even work for me, but that turned 
> out to be an unrelated bug).
> 
> It's very irritating when a working machine suddenly just stops working 
> because some config option just changed its meaning. VERY irritating.

Agreed. I like Ingo's Kconfig patch which forces both drivers
(e1000 and e1000e) to be built the same way (ie both modules or both
builtin).

grant
