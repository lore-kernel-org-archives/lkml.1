Return-Path: <linux-kernel-owner+w=401wt.eu-S1767105AbXEBSOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767105AbXEBSOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767107AbXEBSOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:14:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:55034 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767105AbXEBSOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:14:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,481,1170662400"; 
   d="scan'208";a="223232121"
Message-ID: <4638D51C.7010603@intel.com>
Date: Wed, 02 May 2007 11:14:52 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Michel Lespinasse <walken@zoy.org>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Jeb Cramer <cramerj@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: 24 lost ticks with 2.6.20.10 kernel
References: <20070501130715.GB29131@zoy.org> <46375E04.5030506@redhat.com> <20070501214912.GA4048@zoy.org> <4637BA70.8000108@intel.com> <20070502084146.GA6089@zoy.org>
In-Reply-To: <20070502084146.GA6089@zoy.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 May 2007 18:14:53.0093 (UTC) FILETIME=[C7CE3D50:01C78CE5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:
>> I've had good results with 2.6.21.1 (even running tickless :)) on these 
>> NICs. Have you tried that yet?
> 
> Not yet. Coming up... I'd prefer not to rely on new kernels at this
> point though - but I can certainly try it just to report on current status.

I just checked and the fix I was referring to earlier didn't make it into 
2.6.21-final. You can get 2.6.21-git1 from kernel.org which has the fix. See

http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.21-git1.log

for the changelog and commit id's for the patch:

commit c58b8e4a25a1ba347a0e5d21984c97bd296f1691
Merge: afc2e82... f50393f...
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Fri Apr 27 10:14:53 2007 -0700

     Merge branch 'e1000-fixes' of 
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6

     * 'e1000-fixes' of 
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6:
       e1000: FIX: Stop raw interrupts disabled nag from RT
       e1000: FIX: firmware handover bits
       e1000: FIX: be ready for incoming irq at pci_request_irq

Please give this a try and see if it resolves your issues.

hth,

Auke
