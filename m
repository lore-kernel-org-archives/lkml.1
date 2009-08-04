Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbZHDJSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbZHDJSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932686AbZHDJSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:18:11 -0400
Received: from mga06.intel.com ([134.134.136.21]:42839 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932683AbZHDJSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:18:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,320,1246863600"; 
   d="scan'208";a="538419706"
Message-ID: <4A77FCCC.7040608@linux.intel.com>
Date: Tue, 04 Aug 2009 11:18:04 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
CC: "H.Peter Anvin" <hpa@zytor.com>, LKLM <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] x86, mce: cleanup initcall of debugfs for mce
References: <4A77CEAB.4030909@np.css.fujitsu.com>
In-Reply-To: <4A77CEAB.4030909@np.css.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  int mce_severity(struct mce *a, int tolerant, char **msg);
> -struct dentry *mce_get_debugfs_dir(void);
> +int __init severities_debugfs_init(struct dentry *dmce);

__init is not needed on prototypes.

Sorry but I think it's better to have an own initcall per file,
that makes everything more self contained and easier to read.

-Andi

