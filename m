Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbZI2XCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbZI2XCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZI2XCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:02:47 -0400
Received: from mga10.intel.com ([192.55.52.92]:32754 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751999AbZI2XCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:02:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,475,1249282800"; 
   d="scan'208";a="731382955"
Message-ID: <4AC2921F.8080900@linux.intel.com>
Date: Wed, 30 Sep 2009 01:02:55 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, mce: rename finished to valid in struct mce
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com> <4AC05CFC.4020702@jp.fujitsu.com> <4AC0FF58.5040302@linux.intel.com> <4AC1C80F.8010904@jp.fujitsu.com>
In-Reply-To: <4AC1C80F.8010904@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> At least I could not figure out why we need to pass the value of .finished
> from/to user space.

You shouldn't afaik. The injector overwrites it in the kernel anyways.

-Andi
