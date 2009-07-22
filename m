Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbZGVCF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbZGVCF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 22:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbZGVCF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 22:05:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:20691 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbZGVCF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 22:05:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,243,1246863600"; 
   d="scan'208";a="432235374"
Subject: Re: linux-next: manual merge of the net tree with the
 wireless-current tree
From: Zhu Yi <yi.zhu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ortiz, Samuel" <samuel.ortiz@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20090722115956.482777b4.sfr@canb.auug.org.au>
References: <20090722115956.482777b4.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 10:05:21 +0800
Message-Id: <1248228321.3747.48.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 09:59 +0800, Stephen Rothwell wrote:
> Hi David,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/wireless/iwmc3200wifi/netdev.c between commit
> 513a2396d8e8327aff1ce50bea3fb4f16ff3455b ("iwmc3200wifi: fix NULL pointer
> dereference in iwm_if_free") from the wireless-current tree and commit
> 3549716484a95fd16f7fcf8b68699bd4c803b382 ("iwmc3200wifi: cache keys when
> interface is down") from the net tree.
> 
> Just context changes.   I fixed it up (see below) and can carry the fix
> as necessary.

Hi Stephen,

The correct fix should be
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=126e91ba8cfe45a772aad2f51049ac7cedf5bbfd

We need to make the free wdev the last one.

Thanks,
-yi

