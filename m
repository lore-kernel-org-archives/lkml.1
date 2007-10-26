Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbXJZLGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbXJZLGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXJZLGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:06:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50146
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbXJZLGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:06:32 -0400
Date: Fri, 26 Oct 2007 04:06:31 -0700 (PDT)
Message-Id: <20071026.040631.89479668.davem@davemloft.net>
To: dlstevens@us.ibm.com
Cc: vladislav.yasevich@hp.com, bunk@kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org
Subject: Re: [2.6 patch] unexport icmpmsg_statistics
From: David Miller <davem@davemloft.net>
In-Reply-To: <OF03E20988.736A2E51-ON8825737E.007067FE-8825737E.0071B902@us.ibm.com>
References: <471FAA03.9090003@hp.com>
	<OF03E20988.736A2E51-ON8825737E.007067FE-8825737E.0071B902@us.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Stevens <dlstevens@us.ibm.com>
Date: Wed, 24 Oct 2007 13:43:14 -0700

> So, I stand corrected, and sorry about the histrionics. Since
> these are arguably ICMP errors, and since errors is the only
> thing being MIB-counted in DCCP and SCTP, then it now looks
> ok to me as-is, and also ok to remove icmpmsg_statistics from
> exporting.

I've applied Adrian's export removal patch, thanks!
