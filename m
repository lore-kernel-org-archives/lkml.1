Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbZJIBzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbZJIBzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 21:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbZJIBzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 21:55:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:47860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760170AbZJIBzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 21:55:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,529,1249282800"; 
   d="scan'208";a="501309103"
Subject: Re: [PATCH 6/6] mce-inject: use injected mce only during faked
 handler call
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AC96391.1060001@jp.fujitsu.com>
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 09:54:59 +0800
Message-Id: <1255053299.5228.28.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 11:10 +0800, Hidetoshi Seto wrote: 
> +/*
> + * For error injection
> + */
> +
> +struct mce_fake_banks {
> +	int valid;
> +	struct mce injectm;
> +};

There are some bits available in mce.inject_flags. I don't think it is
necessary to add another variable just for another flag.

Best Regards,
Huang Ying


