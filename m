Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYDHUM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYDHUM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYDHUMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:12:46 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:41024 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbYDHUMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:12:45 -0400
Message-ID: <47FBD1AD.1080700@isomerica.net>
Date: Tue, 08 Apr 2008 16:12:29 -0400
From: Dan Noe <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Ingo Molnar <mingo@elte.hu>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] e1000e broke e1000
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <36D9DB17C6DE9E40B059440DB8D95F5204E2A55C@orsmsx418.amr.corp.intel.com> <20080408195949.GB28148@elte.hu> <20080408200417.GI11962@parisc-linux.org>
In-Reply-To: <20080408200417.GI11962@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> It's almost trivial to add new string attributes to sysfs.  We could
> have a file, say, /sys/bus/pci/devices/0000:07:03.0/broken which
> lspci could read to see if anything's left a message for us.
> 
> Is that the kind of thing you had in mind?

I would consider this a worthwhile addition to the kernel (and lspci). 
It would be nice if lspci could display what driver had claimed a 
particular device, and which devices were unclaimed by any driver or 
otherwise had an error that prevented initialization.

I don't have enough experience to gauge how invasive this would be, but 
I'd be happy to contribute towards it if practical.

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Daniel Noe
                     |  http://isomerica.net/~dpn/
