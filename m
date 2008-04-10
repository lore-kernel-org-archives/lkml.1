Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbYDJSce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbYDJSce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 14:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbYDJScX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 14:32:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:60252 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371AbYDJScW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 14:32:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,637,1199692800"; 
   d="scan'208";a="314564236"
Message-ID: <47FE5BE8.9000206@intel.com>
Date: Thu, 10 Apr 2008 11:26:48 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Grant Grundler <grundler@parisc-linux.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, Frans Pop <elendil@planet.nl>,
       Ingo Molnar <mingo@elte.hu>, jeff@garzik.org, auke-jan.h.kok@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, linux-pci@atrey.karlin.mff.cuni.cz,
       akpm@linux-foundation.org, davem@davemloft.net,
       jesse.brandeburg@intel.com, john.ronciak@intel.com,
       bruce.w.allan@intel.com, greg@kroah.com, arjan@linux.intel.com,
       rjw@sisk.pl
Subject: Re: [patch] e1000=y && e1000e=m regression fix
References: <20080408203314.GA28952@elte.hu> <47FBDBE9.9040700@garzik.org> <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <200804092249.23111.elendil@planet.nl> <m363uqwpds.fsf@maximus.localdomain> <alpine.LFD.1.00.0804091838330.3143@woody.linux-foundation.org> <m34paaav7o.fsf@maximus.localdomain> <alpine.LFD.1.00.0804100724220.3143@woody.linux-foundation.org> <20080410175503.GA11440@colo.lackof.org> <20080410180412.GV11962@parisc-linux.org>
In-Reply-To: <20080410180412.GV11962@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Apr 2008 18:27:56.0011 (UTC) FILETIME=[98900BB0:01C89B38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Apr 10, 2008 at 11:55:03AM -0600, Grant Grundler wrote:
>> Agreed. I like Ingo's Kconfig patch which forces both drivers
>> (e1000 and e1000e) to be built the same way (ie both modules or both
>> builtin).
> 
> Uh, that's /not/ what Ingo's patch does.  His patch makes e1000 claim
> the e1000e IDs if e1000 is built-in and e1000e is a module.

It does? that's definately not the right thing to do at all, so I'd like to
retract my ACK to that patch.

We want to move users over to e1000e, because with 2.6.26 they must (or at one
point in time anyway).

I'm all for making the move easier, but I'm really against prolonging these hacks
that make people just bump their noses later. If they hit the problem now instead
of when 2.6.26 ships, then it's all for the better IMHO.

Auke
