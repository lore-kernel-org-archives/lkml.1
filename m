Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZI2IlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZI2IlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 04:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZI2IlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 04:41:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59385 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZI2IlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 04:41:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC1C80F.8010904@jp.fujitsu.com>
Date: Tue, 29 Sep 2009 17:40:47 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, mce: rename finished to valid in struct mce
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com> <4AC05CFC.4020702@jp.fujitsu.com> <4AC0FF58.5040302@linux.intel.com>
In-Reply-To: <4AC0FF58.5040302@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> struct mce is exported to user space. I don't think it's a good idea
> to rename fields in exported structures like this.  That just causes confusion.

I don't know any other real user of this struct than the mcelog and the
mce test suite.  In other words, I expected that you (Huang and Andi) are
only users who may be confused by this kind of change.

I believe this exported struct is not well defined.
At least I could not figure out why we need to pass the value of .finished
from/to user space.

However, this change is not urgent thing.  I'll put aside this for now.


Thanks,
H.Seto

