Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbZD2TP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbZD2TP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZD2TPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:15:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:62191 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZD2TPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:15:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,267,1239001200"; 
   d="scan'208";a="511062941"
Message-ID: <49F8A734.8050106@linux.intel.com>
Date: Wed, 29 Apr 2009 21:15:00 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer II
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <49EEFD88.1030604@linux.intel.com> <49EF3DE2.6000201@zytor.com>
In-Reply-To: <49EF3DE2.6000201@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Andi Kleen wrote:
>> And then restart here? Add 32bit workarounds, add hook
>> to initialize p5/winchip, make 64bit code 32bit clean.
>> That can come straight from my patchkit. I can do that
>> if there is interest.
>>
> 
> Could you come up with a tree we can look at?

Sorry for taking longer, had to fight some infrastructure issues.

I merged the two trees in
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git mce-32bit-merge

This is my old 32bit mce unification tree forward ported to mce2 and some fixes
for the code in mce2. This is currently with Kconfig for old/new, deprecation
of old for .32 (could be done directly too, but doing it with this additional
step seems safer to me because it will allow easier debugging)

This currently includes the two error injection patches as last (used
for testing), those can be dropped/added later of course too.

If this is ok I can respin the rest of the mce patches on top of that
tree.

-Andi


