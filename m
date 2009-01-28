Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZA1Ey0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZA1Ey0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZA1EyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:54:17 -0500
Received: from mga07.intel.com ([143.182.124.22]:27327 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752486AbZA1EyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:54:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,336,1231142400"; 
   d="scan'208";a="104484453"
Message-ID: <497FE4E7.8070303@linux.intel.com>
Date: Tue, 27 Jan 2009 20:53:59 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, anton@samba.org
Subject: Re: [PATCH] bootgraph: fix for use with dot symbols
References: <19599.1233113450@neuling.org>
In-Reply-To: <19599.1233113450@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling wrote:
> powerpc has dot symbols, so the dmesg output looks like:
>  
> <4>[    0.327310] calling  .migration_init+0x0/0x9c @ 1
> <4>[    0.327595] initcall .migration_init+0x0/0x9c returned 1 after 0 usecs
> 
> The below fixes bootgraph.pl so it handles this correctly.  


question for the ppc folks.... why does the "print symbol" magic format string
thing print a dot symbol and not the real function name?
Should that be fixed instead?
