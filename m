Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbYGCMap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbYGCMap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYGCMaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:30:35 -0400
Received: from corto.dsf.unica.it ([192.84.153.134]:39479 "EHLO
	corto.dsf.unica.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYGCMae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:30:34 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 08:30:33 EDT
Date: Thu, 3 Jul 2008 11:19:20 +0200 (CEST)
From: Giacomo Mulas <gmulas@ca.astro.it>
Reply-To: Giacomo Mulas <gmulas@ca.astro.it>
To: Johannes Berg <johannes@sipsolutions.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       debian-kernel@lists.debian.org,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: b43 locks the machine when resuming after suspend to disk
In-Reply-To: <1215040064.13270.20.camel@johannes.berg>
Message-ID: <alpine.DEB.1.10.0807031118590.2010@capitanata.ca.astro.it>
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>  <200807022340.31894.rjw@sisk.pl> <1215039419.13270.18.camel@johannes.berg>  <200807030108.37614.rjw@sisk.pl> <1215040064.13270.20.camel@johannes.berg>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008, Johannes Berg wrote:

> This seems very odd though, Giacomo, are you sure it also happens if you
> unload the module?

yes, absolutely (unfortunately). I can unload the module before suspending,
reload it after resuming, same result; I can actually do any number of
suspend/resumes, unload and reload the modules any number of times,
everything still works until I try to ifconfig up the interface, then it
hangs solid. I also tried old-style suspend to disk, suspend2, user-space
suspend... exactly the same.

I am now compining a kernel with the patch you sent, to see whether this
improves things. I will let you know. By the way, is there a module
debugging option I could use to cause the b43 and/or mac80211 modules to use
lots of printk's, so that I could at least give you a hint as to where the
code hangs?

Thanks, bye
Giacomo

P.S. please CC replies to me, I'm not on the list(s)

-- 
_________________________________________________________________

Giacomo Mulas <gmulas@ca.astro.it>
_________________________________________________________________

OSSERVATORIO ASTRONOMICO DI CAGLIARI
Str. 54, Loc. Poggio dei Pini * 09012 Capoterra (CA)

Tel. (OAC): +39 070 71180 248     Fax : +39 070 71180 222
Tel. (UNICA): +39 070 675 4916
_________________________________________________________________

"When the storms are raging around you, stay right where you are"
                          (Freddy Mercury)
_________________________________________________________________
