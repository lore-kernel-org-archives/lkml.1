Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbYJ1FYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbYJ1FYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYJ1FX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:23:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:49946 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYJ1FX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:23:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,496,1220252400"; 
   d="scan'208";a="66208514"
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
From: Zhu Yi <yi.zhu@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mirco Tischler <mt-ml@gmx.de>, lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20081027213217.53558319@infradead.org>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	 <1225157618.2917.215.camel@debian.sh.intel.com>
	 <20081027213217.53558319@infradead.org>
Content-Type: text/plain
Organization: Intel Corp.
Date: Tue, 28 Oct 2008 13:23:34 +0800
Message-Id: <1225171414.2917.229.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 22:32 -0600, Arjan van de Ven wrote:
> I had this same issue
> 
> turning on CONFIG_WIRELESS_OLD_REGULATORY fixed it for me....

Arjan,

This is a different bug. He has the wireless worked sometimes.

I think your problem relates to 5GHz channel usage. We have already a
patch queued to resolve the problem. We will have regulatory framework
reworked to better solve the problem. But I guess it will be in .29 time
frame.

Thanks,
-yi

