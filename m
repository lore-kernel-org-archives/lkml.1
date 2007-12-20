Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbXLTUEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbXLTUEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbXLTUEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:04:23 -0500
Received: from mga07.intel.com ([143.182.124.22]:35243 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754589AbXLTUEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:04:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,191,1196668800"; 
   d="scan'208";a="346337398"
Message-ID: <476AC59B.1090702@linux.intel.com>
Date: Thu, 20 Dec 2007 20:42:19 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       parag.warudkar@gmail.com, netdev@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sky2: Use deferrable timer for watchdog
References: <Pine.LNX.4.64.0712182008160.3616@mini.warudkars.net>	<20071220091603.0d69b045@deepthought>	<823114761-1198171803-cardhu_decombobulator_blackberry.rim.net-937108990-@bxe019.bisx.prod.on.blackberry> <20071220095121.7859c023@deepthought> <476ABDDF.8080607@intel.com> <476ABE7D.60901@linux.intel.com> <476AC105.9090206@intel.com>
In-Reply-To: <476AC105.9090206@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:

> ok, that's just bad and if there's no user-defineable limit to the deferral I
> definately don't like this change.
> 
> Can I safely assume that any irq will cause all deferred timers to run?

*on that cpu*. Timers are per cpu, as are interrupts. Just not per se the same one ...

