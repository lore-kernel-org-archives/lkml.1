Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYDHVJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYDHVJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYDHVJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:09:13 -0400
Received: from jabberwock.ucw.cz ([89.250.246.4]:37229 "EHLO jabberwock.ucw.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbYDHVJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:09:09 -0400
X-Greylist: delayed 1868 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2008 17:09:08 EDT
Date: Tue, 8 Apr 2008 22:35:55 +0200
From: Martin Mares <mj@ucw.cz>
To: Rick Jones <rick.jones2@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: showing which hardware is unclaimed
Message-ID: <mj+md-20080408.203457.10351.albireo@ucw.cz>
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <36D9DB17C6DE9E40B059440DB8D95F5204E2A55C@orsmsx418.amr.corp.intel.com> <20080408195949.GB28148@elte.hu> <20080408200417.GI11962@parisc-linux.org> <47FBD1CD.6090009@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FBD1CD.6090009@hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> FWIW, this is what a command on "another OS" does with an unclaimed card:
> 
> # ioscan -fk -C lan
> Class     I  H/W Path  Driver  S/W State   H/W Type     Description
> ====================================================================
> lan       0  0/0/3/0   intl100   CLAIMED     INTERFACE    Intel PCI Pro 
> 10/100Tx Server Adapter
> lan       1  0/1/2/0   igelan    CLAIMED     INTERFACE    HP PCI 
> 1000Base-T Core
> lan       2  0/2/1/0   iether    CLAIMED     INTERFACE    HP A7012-60001 
> PCI/PCI-X 1000Base-T Dual-port Adapter
> lan       3  0/2/1/1   iether    CLAIMED     INTERFACE    HP A7012-60001 
> PCI/PCI-X 1000Base-T Dual-port Adapter
> lan       4  0/3/1/0   ixgbe     UNCLAIMED   UNKNOWN      PCI-X Ethernet 
> (17d55831)
> 
> I'd probably call that "unclaimed" rather than "broken" but that may 
> just be a preference thing.

`lspci -k' already reports which devices are claimed by which driver.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
MS has designed a perfect copy protection scheme: There is no reason to pirate Vista.
