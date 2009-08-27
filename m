Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbZH0JI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbZH0JI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZH0JI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:08:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:14626 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZH0JIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:08:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,285,1249282800"; 
   d="scan'208";a="443177817"
Message-ID: <4A964D01.4090608@linux.intel.com>
Date: Thu, 27 Aug 2009 11:08:17 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
CC: "H.Peter Anvin" <hpa@zytor.com>, LKLM <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] x86, mce: reset kernel for no-match exception errors
References: <4A9646A2.6080605@np.css.fujitsu.com>
In-Reply-To: <4A9646A2.6080605@np.css.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jin Dongming wrote:
> The last case of severity table is used for no match exception error.
> Maybe such kind of error could not happen. But I think when the error
> really happened, the kernel should be reset. Because such error is
> unknown and unexpected. So I make this patch for fixing this problem.

I don't think panicing for a non-signalled error is the correct action.

In general I tried to be conservative regarding panics, this seems
to be too liberal with them.

-Andi
