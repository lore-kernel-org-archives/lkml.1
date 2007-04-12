Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbXDLXPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbXDLXPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXDLXPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:15:44 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:6924 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbXDLXPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:15:40 -0400
X-IronPort-AV: i="4.14,405,1170662400"; 
   d="scan'208"; a="135247547:sNHT45838503"
To: CaT <cat@zip.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: intermittant petabyte usage reported with broadcom nic
X-Message-Flag: Warning: May contain useful information
References: <20070402014319.GA8345@zip.com.au>
	<20070402001300.3b66007d.akpm@linux-foundation.org>
	<20070412225249.GU8345@zip.com.au>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 12 Apr 2007 16:15:26 -0700
In-Reply-To: <20070412225249.GU8345@zip.com.au> (cat@zip.com.au's message of "Fri, 13 Apr 2007 08:52:49 +1000")
Message-ID: <adaslb5dw1d.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Apr 2007 23:15:27.0184 (UTC) FILETIME=[74B32500:01C77D58]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Apr  9 06:19:04 '  eth0:14250798570591813804 2284720007938 18638    0    0 18638          0  27375938 1556640980159 3345714490    0    0    0     0       0          0 '

One odd thing is that crazy number 14250798570591813804 is
c5c501cbc5c500ac in hex.  I dunno what the significant of the 0xc5 bit
pattern is though...

The other line has 220898233988841368, which is 0x310c9c6006a7f98, not
nearly so regular a patter.

I don't think I'm helping much...
