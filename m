Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZIWPWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZIWPWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZIWPWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:22:22 -0400
Received: from mga12.intel.com ([143.182.124.36]:60219 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750911AbZIWPWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:22:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,439,1249282800"; 
   d="scan'208";a="190792241"
Message-ID: <4ABA3D31.8020507@linux.intel.com>
Date: Wed, 23 Sep 2009 17:22:25 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:x86/mce3] x86, mce: use 64bit machine	check
 code on 32bit
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu> <4A891E17.1090901@jp.fujitsu.com> <20090817092047.GB21269@elte.hu> <4A893A14.1070103@linux.intel.com> <20090922154157.GA17497@elte.hu>
In-Reply-To: <20090922154157.GA17497@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> Your sloppiness of not fixing mce_rdmsrl() as i requested brought us 
> this new boot crash regression in 2.6.31, in mce_rdmsrl():

Ingo, that's because the MSRs already have capability bits. If the
capability bits don't work we have to find out why, not hack around
without understanding it it by using rdmsrl_safe(). Most likely something
more is wrong then and it has to be fixed properly.

I'll work with the reporter to find out what the problem is.
Thanks for bringing that bug to my attention.

-Andi


