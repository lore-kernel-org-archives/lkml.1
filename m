Return-Path: <linux-kernel-owner+w=401wt.eu-S1945940AbXDCVAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945940AbXDCVAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXDCVAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:00:34 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:59316 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbXDCVAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:00:33 -0400
Date: Tue, 3 Apr 2007 22:57:44 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Christian Kujau <evil@g-house.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, malte@g-house.de
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
Message-ID: <20070403205744.GB12969@electric-eye.fr.zoreil.com>
References: <Pine.LNX.4.64.0704022012300.3963@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704022012300.3963@sheep.housecafe.de>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau <evil@g-house.de> :
[...]
> Please see http://nerdbynature.de/bits/2.6.20.4/ for details for both 
> hosts and feel free to ask for more details. Although both boxes are in 
> production we'll be happy test more bootoptions/patches and the like.

If the apic voodoo makes no difference, you can:
1 - leave it enabled
2 - check that netconsole is not used with the 8139 (it is busted)
3 - check that netconsole is not used at all
4 - try:
    http://www.fr.zoreil.com/linux/kernel/2.6.x/2.6.21-rc5/r8169-20070402

-- 
Ueimor
