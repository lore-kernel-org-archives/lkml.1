Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYDJVUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYDJVUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 17:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYDJVUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 17:20:30 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:43331 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbYDJVU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 17:20:29 -0400
Message-ID: <47FE848D.6050700@nortel.com>
Date: Thu, 10 Apr 2008 15:20:13 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, Frans Pop <elendil@planet.nl>,
       Ingo Molnar <mingo@elte.hu>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, linux-pci@atrey.karlin.mff.cuni.cz,
       akpm@linux-foundation.org, davem@davemloft.net,
       jesse.brandeburg@intel.com, john.ronciak@intel.com,
       bruce.w.allan@intel.com, greg@kroah.com, arjan@linux.intel.com,
       rjw@sisk.pl
Subject: Re: [patch] e1000=y && e1000e=m regression fix
References: <20080408203314.GA28952@elte.hu> <47FBDBE9.9040700@garzik.org> <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <200804092249.23111.elendil@planet.nl> <m363uqwpds.fsf@maximus.localdomain> <alpine.LFD.1.00.0804091838330.3143@woody.linux-foundation.org> <m34paaav7o.fsf@maximus.localdomain> <alpine.LFD.1.00.0804100724220.3143@woody.linux-foundation.org> <20080410175503.GA11440@colo.lackof.org> <20080410180412.GV11962@parisc-linux.org> <47FE5BE8.9000206@intel.com>
In-Reply-To: <47FE5BE8.9000206@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Apr 2008 21:20:18.0343 (UTC) FILETIME=[AD12AB70:01C89B50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:

> We want to move users over to e1000e, because with 2.6.26 they must (or at one
> point in time anyway).
> 
> I'm all for making the move easier, but I'm really against prolonging these hacks
> that make people just bump their noses later. If they hit the problem now instead
> of when 2.6.26 ships, then it's all for the better IMHO.

Obviously e1000e hasn't been out for long enough to become common 
knowledge.  (Both Ingo and Linus running into the problem is probably a 
sign...)

Maybe it would make sense to have "e1000 implies setting e1000e to the 
same as e1000" for a couple releases, so that word gets around a bit 
more.  Then you can remove the auto-select of e1000e and anyone that 
hasn't updated by then will get bit.

Chris
