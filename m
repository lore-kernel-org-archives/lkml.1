Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbXJCSF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbXJCSF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXJCSFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:05:49 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:7649 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbXJCSFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:05:47 -0400
X-IronPort-AV: E=Sophos;i="4.21,226,1188802800"; 
   d="scan'208";a="530982206"
To: Paul Mackerras <paulus@samba.org>
Cc: Joachim Fenkes <fenkes@de.ibm.com>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, Paul Mackerras <pmac@au1.ibm.com>
Subject: Re: [PATCH 4/5] ibmebus: Move to of_device and of_platform_driver, match eHCA and eHEA drivers
X-Message-Flag: Warning: May contain useful information
References: <200709261143.24735.fenkes@de.ibm.com>
	<200709261145.51926.fenkes@de.ibm.com>
	<18179.943.277895.633795@cargo.ozlabs.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 03 Oct 2007 11:05:44 -0700
In-Reply-To: <18179.943.277895.633795@cargo.ozlabs.ibm.com> (Paul Mackerras's message of "Wed, 3 Oct 2007 12:51:27 +1000")
Message-ID: <adave9odqfb.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Oct 2007 18:05:44.0949 (UTC) FILETIME=[04B39A50:01C805E8]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Replace struct ibmebus_dev and struct ibmebus_driver with struct of_device
 > > and struct of_platform_driver, respectively. Match the external ibmebus
 > > interface and drivers using it.
 > > 
 > > Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
 > 
 > If not, then you need to get an Acked-by and an agreement that this
 > change can go via the powerpc.git tree from Roland Dreier and Jeff
 > Garzik.

I don't see anything objectionable in the infiniband parts of the
patch -- I don't have any way to test the changes but it all looks
like a straightforward conversion to a new platform API.  So:

Acked-by: Roland Dreier <rolandd@cisco.com>

 - R.
