Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYHSTVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYHSTVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbYHSTVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:21:22 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:45615 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbYHSTVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:21:21 -0400
Message-ID: <48AB1D62.6030406@keyaccess.nl>
Date: Tue, 19 Aug 2008 21:22:10 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Dave Airlie <airlied@gmail.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "dri-users@lists.sourceforge.net" <dri-users@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu> <48A59FAC.7050605@keyaccess.nl> <48AA9C3B.5030309@keyaccess.nl> <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl> <20080819190757.GA17470@linux-os.sc.intel.com>
In-Reply-To: <20080819190757.GA17470@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-08-08 21:07, Venki Pallipadi wrote:

> On Tue, Aug 19, 2008 at 07:19:44AM -0700, Rene Herman wrote:

>> I believe the 14 seconds for first shutdown to 5 later might be
>> telling. Sounds like something might have fixed up uncached
>> entries.
>> 
>> I'd really like a reply from the AGP or PAT side right about now.
> 
> Hmm. Looks like there are more than 16000 entries in the PAT list!
> 
> This delay may be due to the overhead of parsing this linked list
> everytime for a new entry, rather than any problem with cache setting
> itself.
> 
> I am working on a patch to optimize this pat list parsing for the
> simple case. Should be able to send it out later today, for testing.

Thanks for the reply. It's with 64MB of AGP memory which I guess is at 
the low end these days. Would your reply mean that basically everyone on 
2.6.27 should now be experiencing this?

I noticed it was PAT related due to Shaohua Li's:

http://marc.info/?l=linux-kernel&m=121783222306075&w=2

which lists very different times (patch there did not help any).

As another by the way, probably not surprising but I earlier also tried 
  both unmounting and completely compiling out debugfs just in case I 
was seeing a debugging related sysmptom. No help either.

It's evening here so I'll probably not be able to test until tomorrow.

Rene.
