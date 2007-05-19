Return-Path: <linux-kernel-owner+w=401wt.eu-S1765058AbXESWih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765058AbXESWih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762120AbXESWi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:38:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45028
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756099AbXESWi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:38:27 -0400
Date: Sat, 19 May 2007 15:38:29 -0700 (PDT)
Message-Id: <20070519.153829.112852602.davem@davemloft.net>
To: michal.k.k.piotrowski@gmail.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       auke-jan.h.kok@intel.com, doug.chapman@hp.com, cramerj@intel.com,
       john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, e1000-devel@lists.sourceforge.net,
       bcollins@ubuntu.com, yoshfuji@linux-ipv6.org
Subject: Re: [5/5] 2.6.22-rc2: known regressions
From: David Miller <davem@davemloft.net>
In-Reply-To: <464F74E9.8080102@googlemail.com>
References: <464F6DC9.80805@googlemail.com>
	<464F74E9.8080102@googlemail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Date: Sun, 20 May 2007 00:06:33 +0200

> Subject    : OOPS triggered by ip(8) deconfiguring a network interface
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8491
> Submitter  : Ben Collins <bcollins@ubuntu.com>
> Status     : Unknown

Might be fixed by:

	http://marc.info/?l=linux-netdev&m=117915849224816&w=2

I'll merge that patch in and we'll see what happens.
