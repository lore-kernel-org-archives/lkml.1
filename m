Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYHOPYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYHOPYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYHOPX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:23:57 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:37887 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbYHOPX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:23:57 -0400
Message-ID: <48A59FAC.7050605@keyaccess.nl>
Date: Fri, 15 Aug 2008 17:24:28 +0200
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
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu>
In-Reply-To: <20080815142218.GC12954@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-08-08 16:22, Ingo Molnar wrote:

> (more people Cc:-ed)

Thank you. Additional information at http://lkml.org/lkml/2008/8/6/449

> agreed - +12 seconds wait suggest some rather fundamental breakage.
> Did we go back to uncached for some critical display area that makes
> X start up (shut down) that slowly? Did we mark the BIOS uncacheable
> perhaps, causing X to execute BIOS code very slowly?

Quite a lot "uncached-minus" in those lists. I am desperately trying to 
avoid a clue about mostly anything graphics related so, "I dunno".

I haven't just disabled PAT yet (although I was about to just do so) and 
am available for testing.

Rene.
