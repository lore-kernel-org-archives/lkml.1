Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbXIQQJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbXIQQJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbXIQQJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:09:11 -0400
Received: from mga10.intel.com ([192.55.52.92]:20307 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752399AbXIQQJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:09:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,265,1186383600"; 
   d="scan'208";a="141456492"
Message-ID: <46EEA6A2.2080001@ichips.intel.com>
Date: Mon, 17 Sep 2007 09:09:06 -0700
From: Sean Hefty <mshefty@ichips.intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       rdreier@cisco.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Re: [PATCH v2] iw_cxgb3: Support "iwarp-only" interfaces
 to avoid 4-tuple conflicts.
References: <20070913191617.30937.95960.stgit@dell3.ogc.int>	<20070914130941.GG18517@2ka.mipt.ru> <46EC00BE.3020801@opengridcomputing.com>
In-Reply-To: <46EC00BE.3020801@opengridcomputing.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +    addr = kmalloc(sizeof *addr, GFP_KERNEL);
>>
>> As a small nitpick: this wants to be sizeof(struct in_ifaddr)

See chapter 14 of CodingStyle document.  kmalloc(sizeof *addr... is correct.

- Sean
