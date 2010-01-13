Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645Ab0AMWa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab0AMWa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629Ab0AMWaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:30:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:41237 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab0AMWaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:30:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,270,1262592000"; 
   d="scan'208";a="483782299"
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4B4E48BB.5030902@zytor.com>
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org>
	 <1263338274-6485-5-git-send-email-yinghai@kernel.org>
	 <1263340563.2854.1011.camel@sbs-t61.sc.intel.com>
	 <4B4D0E39.10200@kernel.org> <87tyupfzk8.fsf@basil.nowhere.org>
	 <4B4E427D.9090207@zytor.com> <20100113222348.GE24818@basil.fritz.box>
	 <4B4E48BB.5030902@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 13 Jan 2010 14:29:13 -0800
Message-Id: <1263421753.2865.103.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 14:27 -0800, H. Peter Anvin wrote:
> On 01/13/2010 02:23 PM, Andi Kleen wrote:
> >> There are configurations in which percpu memory is in the megabytes.
> > 
> > There used to be some like this (with some broken debug code), but they
> > got all fixed i believe to only allocate on real cpu hotplug. 
> > 
> > If not the right way is to fix them, not add DMI blacklists.
> > 
> > Beside when you enable debug code you probably don't care about 
> > a few MB too much.
> > 
> >> This is exactly why we need high water mark allocation of percpu memory:
> > 
> > No we just need to fix any percpu pigs (if there are really any left,
> > I did a couple of patches some time ago)
> > 
> > "Don't work around broken code -- fix it"
> > 
> 
> Well, that *is* working around broken code, in this case the broken code
> is the percpu allocation strategy.

Andi, Recently percpu folks changed the per-cpu static first chunk to
PMD SIZE right. I think that is what causing all this issue.

thanks,
suresh

