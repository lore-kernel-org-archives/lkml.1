Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYDHUwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYDHUwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbYDHUvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:51:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:1460 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbYDHUvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:51:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,625,1199692800"; 
   d="scan'208";a="313869231"
Message-ID: <47FBD9CD.8060008@intel.com>
Date: Tue, 08 Apr 2008 13:47:09 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       NetDev <netdev@vger.kernel.org>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <greg@kroah.com>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [E1000-devel] [regression] e1000e broke e1000
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu>	<47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu>	<20080408193245.GG11962@parisc-linux.org>	<20080408195123.GA28148@elte.hu> <47FBCE00.2020309@garzik.org>	<20080408200652.GC28148@elte.hu> <47FBD34A.6080508@garzik.org> <20080408203314.GA28952@elte.hu>
In-Reply-To: <20080408203314.GA28952@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Ingo Molnar wrote:
>>> i repeat, it took me more than an hour to figure out why there's no 
>>> networking on my laptop. Guess how much it takes for a plain user to 
>>> figure out the same problem.
>> A plain user would have obtained a working distro kernel, putting this 
>> rare problem purely in the laps of people with highly unusual kernel 
>> configs...
>>
>> But as noted in the announcement, the fix is for this is to continue 
>> in the next step in the transition, then you only have one driver 
>> claiming those IDs, for any given config.  No need for further Kconfig 
>> tweakage.
> 
> i find it mindboggling and rather sad that you are still in denial :-(
> 
> this is an obvious regression to me, with a very simple fix. No other 
> PCI driver breaks like this. We've got three thousand Kconfig options - 
> it is clearly not realistic for users to keep such details in mind to 
> avoid pitfalls. E1000=y && E1000E=m is uncommon but can easily happen. 
> E1000=y && E1000E=m simply makes no sense in light of the PCI ID 
> stealing that occurs if E1000E is enabled.

hence the patch that is in jeff's upstream tree that puts an end to this :)

Auke


