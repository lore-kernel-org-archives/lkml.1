Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZI2Up0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZI2Up0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZI2Up0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:45:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:33639 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZI2UpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:45:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,475,1249282800"; 
   d="scan'208";a="554895485"
Message-ID: <4AC271EE.30201@linux.intel.com>
Date: Tue, 29 Sep 2009 22:45:34 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] mce-inject: make injected mce valid only during faked
 handler call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com> <4AC05D48.1000007@jp.fujitsu.com> <4AC10588.90808@linux.intel.com> <4AC1C889.705@jp.fujitsu.com>
In-Reply-To: <4AC1C889.705@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Andi Kleen wrote:
>>> This has an undesired side-effect: it is possible for it to be
>>> consumed by real machine_check_poll. This may confuse a real system
>>> error and may confuse the mce test suite.
>> You can just disable the poll handler in the test suite. That's
>> what we did.
> 
> I'd like to fix this simply, rather than providing documentation like
> "you should turn off polling before you use the mce-inject."

We already fixed the documentation to include that. mce-inject is not expected
to be used by unskilled users, so relying in documentation is ok.

-Andi
