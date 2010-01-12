Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484Ab0ALBiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab0ALBiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204Ab0ALBiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:38:15 -0500
Received: from mga05.intel.com ([192.55.52.89]:53819 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751140Ab0ALBiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:38:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,258,1262592000"; 
   d="scan'208";a="530418752"
Message-ID: <4B4BD281.4080009@linux.intel.com>
Date: Tue, 12 Jan 2010 02:38:09 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Wu Fengguang <fengguang.wu@intel.com>,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH - resend] Memory-Hotplug: Fix the bug on interface /dev/mem
 for 64-bit kernel(v1)
References: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com>	<20100108124851.GB6153@localhost>	<DA586906BA1FFC4384FCFD6429ECE86031560FC1@shzsmsx502.ccr.corp.intel.com>	<20100111124303.GA21408@localhost> <20100112093031.0fc6877f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100112093031.0fc6877f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hmmm....could you rewrite /dev/mem to use kernel/resource.c other than
> modifing e820 maps. ?

Sorry but responding to bug fixes with "could you please rewrite ..."  is
not considered fair. Shaohui is just trying to fix a bug here, not redesigning
a subsystem.


> Two reasons.
>   - e820map is considerted to be stable, read-only after boot.
>   - We don't need to add more x86 special codes.

We need working memory hotadd.

-Andi


