Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbXLGBjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbXLGBjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 20:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXLGBjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 20:39:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:51305 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbXLGBjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 20:39:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,264,1194249600"; 
   d="scan'208";a="422561489"
Subject: Re: [PATCH] iwlwifi3945/4965 - fix rate control algo reference leak
From: Zhu Yi <yi.zhu@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>,
       "John W.Linville" <linville@tuxdriver.com>
Cc: Thomas Tuttle <linux-kernel@ttuttle.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Wu <flamingice@sourmilk.net>,
       LWML <linux-wireless@vger.kernel.org>
In-Reply-To: <20071206093922.GA7356@cvg>
References: <20071206093922.GA7356@cvg>
Content-Type: text/plain
Organization: Intel Corp.
Date: Fri, 07 Dec 2007 09:39:33 +0800
Message-Id: <1196991573.3170.43.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-06 at 12:39 +0300, Cyrill Gorcunov wrote:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Subject: [PATCH] iwlwifi3945/4965 - fix rate control algo reference leak
> 
> This patch does fix rate control algo reference leak in case
> if network device has been failed to register. In this case
> special flag priv->mac80211_registered is not set and the
> rate algo reference is not freeing on module unload. That leads
> to OOPs in further ieee80211 rate register/unregister procedure
> (by any callee).
> 
> It should fix the bug #9470
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=9470
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
>  drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)

ACK. Thanks for the fix.

John, I think it should be in 2.6.24.

Thanks,
-yi
