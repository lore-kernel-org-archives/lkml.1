Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYHSKKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYHSKKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYHSKK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:10:26 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:60231 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbYHSKKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:10:25 -0400
Message-ID: <48AA9C3B.5030309@keyaccess.nl>
Date: Tue, 19 Aug 2008 12:11:07 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dave Airlie <airlied@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, dri-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu> <48A59FAC.7050605@keyaccess.nl>
In-Reply-To: <48A59FAC.7050605@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-08-08 17:24, Rene Herman wrote:

> On 15-08-08 16:22, Ingo Molnar wrote:
> 
>> (more people Cc:-ed)
> 
> Thank you. Additional information at http://lkml.org/lkml/2008/8/6/449
> 
>> agreed - +12 seconds wait suggest some rather fundamental breakage.
>> Did we go back to uncached for some critical display area that makes
>> X start up (shut down) that slowly? Did we mark the BIOS uncacheable
>> perhaps, causing X to execute BIOS code very slowly?
> 
> Quite a lot "uncached-minus" in those lists. I am desperately trying to 
> avoid a clue about mostly anything graphics related so, "I dunno".
> 
> I haven't just disabled PAT yet (although I was about to just do so) and 
> am available for testing.

<waiting with bated breath>

Additional observation with respect to first,next shutdown:

With Option "AGPSize" "64", and booted with "nopat", X startup (from 
startx<enter> to functional desktop) is approximately 5 seconds, 
shutdown is 1 second as calibration times.

Booted without "nopat", X startup seems to alternate between 10+ and 16+ 
seconds and for shutdown -- the first shutdown after boot takes some 14 
seconds total, subsequent shutdowns settle at around 5 seconds.

Rene.
