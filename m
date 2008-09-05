Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYIES7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYIES7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYIES7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:59:25 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:43035 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYIES7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:59:24 -0400
X-BigFish: VPS-38(z6f5iz146fK1432R98dR936eQ62a3L1805Mzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K6QKQG-02-CXG-01
Date: Fri, 5 Sep 2008 20:59:08 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: oprofile + hibernation = badness
Message-ID: <20080905185907.GI5417@erda.amd.com>
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com> <48AA1E42.6070802@linux.intel.com> <20080901163452.GD6588@erda.amd.com> <20080905175827.GE27395@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080905175827.GE27395@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Sep 2008 18:59:11.0494 (UTC) FILETIME=[7B930A60:01C90F89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.09.08 19:58:29, Ingo Molnar wrote:
> > this fix (commit id 1404e403) is not yet upstream for v2.6.27. Could
> > this be added to the next pull request?
> 
> it's already upstream, as commit 80a8c9fffa. I've zapped the duplicate 
> 1404e403 from x86/oprofile.

Ah, I stumbled other this because it is still listed in the shortlog:

 $ git shortlog linux-2.6/master..tip/master | grep oprofile
       x86: fix oprofile + hibernation badness
 ...

But anyway, I found the other commit as well, thanks.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

