Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbZJIGvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbZJIGvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 02:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932699AbZJIGvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 02:51:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:30079 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565AbZJIGvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 02:51:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,530,1249282800"; 
   d="scan'208";a="196928802"
Subject: Re: [PATCH 2/4] mce-inject: use individual members instead of
 struct mce
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4ACECDDD.1040206@jp.fujitsu.com>
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com>
	 <1255053299.5228.28.camel@yhuang-dev.sh.intel.com>
	 <4ACECC49.7000602@jp.fujitsu.com>  <4ACECDDD.1040206@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 14:50:40 +0800
Message-Id: <1255071040.5228.147.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 13:45 +0800, Hidetoshi Seto wrote: 
> struct mce have many members and almost half of them are not used
> for mce injection.  So make struct mce_fake_banks to have required
> members instead of having struct mce in it.

I don't think this is necessary. struct mce works fine.

Best Regards,
Huang Ying


