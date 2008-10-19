Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbYJSRGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbYJSRGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 13:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYJSRGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 13:06:12 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:50573 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbYJSRGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 13:06:11 -0400
Date: Sun, 19 Oct 2008 19:05:11 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Joe Harvell <jharvell+lists.linux-kernel@dogpad.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sw-iommu leak with Ethernet jumbo frames and nfs
Message-ID: <20081019170511.GA21266@electric-eye.fr.zoreil.com>
References: <48FA5BDC.6070108@dogpad.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FA5BDC.6070108@dogpad.net>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Harvell <jharvell+lists.linux-kernel@dogpad.net> :
> I noticed a problem with SW-IOMMU allocation failures when using NFS over 
> my PCI Ethernet network interface using jumbo frames.  I think it's a leak, 
> rather than under-engineered because the problem only happens when using 
> NFS and jumbo frames.  When I run netperf at a much higher data rate over 
> the NIC, I don't see any problems.  Also, I think it's a leak because the 
> problem still occurrs very quickly even when I double the SW-IOMMU heap 
[...]
> The Ethernet controller is an on-board Realtek R8110SC using driver r8169.  

This was fixed before 2.6.27 as commit a866bbf6aacf95f849810079442a20be118ce905.

Thanks for the detailled bug report.

-- 
Ueimor
