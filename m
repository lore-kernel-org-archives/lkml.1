Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYFKCbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYFKCbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 22:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbYFKCba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 22:31:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:29493 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249AbYFKCb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 22:31:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,621,1204531200"; 
   d="scan'208";a="290992585"
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080606034738.9835782d.akpm@linux-foundation.org>
References: <200806060039.48488.m1k0@wp.pl>
	 <20080606034738.9835782d.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Intel Corp.
Date: Wed, 11 Jun 2008 10:31:04 +0800
Message-Id: <1213151464.7814.630.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-06 at 03:47 -0700, Andrew Morton wrote:
> > ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > iwl4965: Error sending REPLY_WEPKEY: enqueue_hcmd failed: -5
> > mac80211-phy0: failed to remove key (0, ff:ff:ff:ff:ff:ff) from
> hardware (-5)
> > iwl4965: Error sending REPLY_TX_PWR_TABLE_CMD: enqueue_hcmd failed:
> -5
> > iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
> > iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC

Looks like a rfkill related problem. Can you please try this patch?
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1673

Thanks,
-yi

