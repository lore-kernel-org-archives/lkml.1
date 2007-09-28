Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbXI1WYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbXI1WYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 18:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbXI1WX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 18:23:59 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:29160 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbXI1WX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 18:23:58 -0400
X-IronPort-AV: E=Sophos;i="4.21,211,1188802800"; 
   d="scan'208";a="227287244"
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i915: make vbl interrupts work properly on i965g/gm
X-Message-Flag: Warning: May contain useful information
References: <Pine.LNX.4.64.0709280248480.10526@skynet.skynet.ie>
	<200709271909.23040.jbarnes@virtuousgeek.org>
	<adave9umudh.fsf@cisco.com>
	<200709281307.56037.jbarnes@virtuousgeek.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 28 Sep 2007 15:23:57 -0700
In-Reply-To: <200709281307.56037.jbarnes@virtuousgeek.org> (Jesse Barnes's message of "Fri, 28 Sep 2007 13:07:55 -0700")
Message-ID: <ada1wcimnsy.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Sep 2007 22:23:57.0772 (UTC) FILETIME=[431408C0:01C8021E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I don't have a 945 to test with, but Dave might...

Actually I'm not looking for testing (I can test fine on my own laptop :)
I was just hoping someone with docs could tell me "MSI is documented to be
broken on 945GM" or "Oh yeah, 945GM requires you to set SECRET_MSI_ENABLE_BIT 
in register FOO before it generates MSIs."

As I said, it's not a big deal but I'd sort of like to know whether my
MSI enable hack at least has a chance at working before I try too hard
to get it working.

Thanks,
  Roland
