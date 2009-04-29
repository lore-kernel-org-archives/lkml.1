Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbZD2I2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbZD2I2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZD2I2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:28:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49674 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbZD2I23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:28:29 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "Recalde, Luis F" <luis.f.recalde@intel.com>,
       "Nelson, Doug" <doug.nelson@intel.com>,
       "Cheng, Wu-sun" <wu-sun.cheng@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Shunmuganathan, Rajalakshmi" <rajalakshmi.shunmuganathan@intel.com>,
       "Garg, Anil K" <anil.k.garg@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>
Subject: Re: Mainline kernel OLTP performance update
From: Andi Kleen <andi@firstfloor.org>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F3D6A@azsmsx501.amr.corp.intel.com>
	<20090429002930.b786348b.akpm@linux-foundation.org>
Date: Wed, 29 Apr 2009 10:28:25 +0200
In-Reply-To: <20090429002930.b786348b.akpm@linux-foundation.org> (Andrew Morton's message of "Wed, 29 Apr 2009 00:29:30 -0700")
Message-ID: <871vrbrhhy.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> ======oprofile CPU_CLK_UNHALTED for top 30 functions
>> Cycles% 2.6.24.2                   Cycles% 2.6.30-rc3
>> 74.8578 <database>                 69.1925 <database>
>
> ouch, that's a large drop in userspace CPU occupancy.  It seems
> inconsistent with the 1.91% above.

That was determined to be an oprofile artifact/regression (see Doug's
other email+thread) The 2.6.30 oprofile seems to be less accurate than
the one in 2.6.24. Of course the question is if it can't get
the user space right, is the kernel data accurate. But I believe
Doug verified with vtune that the kernel data is roughly correct,
just user space profiling was slightly bogus (right, Doug, or
do I misrepresent that?)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
