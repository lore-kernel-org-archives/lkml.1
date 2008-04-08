Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYDHUjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYDHUjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYDHUjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:39:36 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:60629 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYDHUjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:39:36 -0400
Message-ID: <47FBD7FE.1060507@isomerica.net>
Date: Tue, 08 Apr 2008 16:39:26 -0400
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
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <36D9DB17C6DE9E40B059440DB8D95F5204E2A55C@orsmsx418.amr.corp.intel.com> <20080408195949.GB28148@elte.hu> <20080408200417.GI11962@parisc-linux.org> <47FBD1AD.1080700@isomerica.net> <20080408202003.GJ11962@parisc-linux.org>
In-Reply-To: <20080408202003.GJ11962@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Apr 08, 2008 at 04:12:29PM -0400, Dan Noe wrote:
>> It would be nice if lspci could display what driver had claimed a 
>> particular device
> 
> You need to upgrade to a more recent version of lspci -- it already does
> this ;-)

Hah, thanks.  That is useful and very new :)  I built a newer lspci and 
I see it is now displayed with the -k option.

> Maybe 'status' would be a better name than 'broken'.  We could even
> default it to 'unclaimed' then.  Or 'driver_status' to avoid conflicting
> with some bus that might have a 'status' bit we try to report through
> sysfs.

I agree however that the opportunity for more status would be good.  And 
status is a better name than "broken".  This way it is easy to scan all 
devices on the system via sysfs and easily visualize via lspci or some 
other tool:

1) Unclaimed devices

2) Devices that aren't working properly - and why (please something more 
than "This device is not working properly" :)

3) Devices that are claimed and working properly

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Daniel Noe
                     |  http://isomerica.net/~dpn/
