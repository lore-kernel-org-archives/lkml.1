Return-Path: <linux-kernel-owner+w=401wt.eu-S938844AbXGSOsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938844AbXGSOsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765988AbXGSOrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:47:49 -0400
Received: from mga06.intel.com ([134.134.136.21]:42503 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764491AbXGSOrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:47:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,557,1175497200"; 
   d="scan'208";a="268175082"
Message-ID: <469F7918.3000503@linux.intel.com>
Date: Thu, 19 Jul 2007 07:45:44 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: does CONFIG_UNUSED_SYMBOLS have any value anymore?
References: <Pine.LNX.4.64.0707190849450.30763@localhost.localdomain> <469F749F.8030606@s5r6.in-berlin.de>
In-Reply-To: <469F749F.8030606@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Robert P. J. Day wrote:
> ...
>> it's not clear if that means that it was a *one-time* transition
>> aid which is now unnecessary, or whether it's an *ongoing* aid which
>> might be used at any time.  currently, there are no invocations of
>> EXPORT_UNUSED_SYMBOL[_GPL] anywhere in the tree.  so does that mean
>> this feature can be tossed?  or might it still be used every so often?

it's one of those pieces of infrastructure that get used from time to 
time to phase out symbol exports... we should be more agressive about 
that; about 1/3rd of the exports is not used by anything in linux, yet 
each symbol costs about 100 bytes of memory at runtime.
