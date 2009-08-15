Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZHON1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZHON1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 09:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZHON1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 09:27:48 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:51872 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZHON1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 09:27:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-disposition: inline
Content-type: Text/Plain; charset=utf-8
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.31-rc6
Date: Sat, 15 Aug 2009 09:27:24 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc6; KDE/4.2.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0908131601100.3162@localhost.localdomain>
In-reply-to: <alpine.LFD.2.01.0908131601100.3162@localhost.localdomain>
Message-id: <200908150927.25005.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Linus Torvalds wrote:
>Hmm. Lots of small fixes all over, spread out fairly evenly (50% drivers,
>and roughly 10% each in arch, fs, kernel, tools/perf, "rest"). And things
>do seem to be calming down, because outside of some further i915
>displayport patches and a couple of perf-counter patches, almost all of
>them are pretty dang small.

[...]

The Netgear WG311NA (marvel 88somethng) pci cards are still on the missing 
list.  I was hoping that flurry of patches to libertas would all get in.

Various snippets from a rebuild:

  MODPOST vmlinux.o                                                                                          
WARNING: modpost: Found 5 section mismatch(es).                                                              
To see full details build your kernel with:                                                                  
'make CONFIG_DEBUG_SECTION_MISMATCH=y'

That has been there forever.

drivers/net/wireless/mwl8k.c: In function ‘mwl8k_config_wt’:                                  
drivers/net/wireless/mwl8k.c:3031: warning: ‘radio_enabled’ is deprecated 
(declared at include/net/mac80211.h:599)

I did see a warning about a type miss-match go by during the build:

drivers/net/wireless/libertas/if_spi.c: In function ‘if_spi_c2h_data’:                                            
drivers/net/wireless/libertas/if_spi.c:739: warning: format ‘%lu’ expects type 
‘long unsigned int’, but argument 4 has type ‘unsigned int’

And later:

net/mac80211/main.c: In function ‘ieee80211_bss_info_change_notify’:                                                                   
net/mac80211/main.c:293: warning: ‘beacon_int’ is deprecated (declared at 
include/net/mac80211.h:593)                                  
net/mac80211/main.c: In function ‘ieee80211_alloc_hw’:                                                                                 
net/mac80211/main.c:714: warning: ‘radio_enabled’ is deprecated (declared at 
include/net/mac80211.h:599)

Other than that the build was fairly clean, and I'm running it.  But still no 
wireless. :(

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Politics are almost as exciting as war, and quite as dangerous.  In war,
you can only be killed once.
		-- Winston Churchill

