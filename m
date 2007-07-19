Return-Path: <linux-kernel-owner+w=401wt.eu-S939612AbXGSPtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939612AbXGSPtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932675AbXGSPtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:49:20 -0400
Received: from mga07.intel.com ([143.182.124.22]:1581 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937618AbXGSPtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:49:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,557,1175497200"; 
   d="scan'208";a="252398991"
Message-ID: <469F8784.3030700@linux.intel.com>
Date: Thu, 19 Jul 2007 08:47:16 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: does CONFIG_UNUSED_SYMBOLS have any value anymore?
References: <Pine.LNX.4.64.0707190849450.30763@localhost.localdomain> <469F749F.8030606@s5r6.in-berlin.de> <469F7918.3000503@linux.intel.com> <Pine.LNX.4.64.0707191133100.7047@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707191133100.7047@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Thu, 19 Jul 2007, Arjan van de Ven wrote:
> 
>> Stefan Richter wrote:
>>> Robert P. J. Day wrote:
>>> ...
>>>> it's not clear if that means that it was a *one-time* transition
>>>> aid which is now unnecessary, or whether it's an *ongoing* aid which
>>>> might be used at any time.  currently, there are no invocations of
>>>> EXPORT_UNUSED_SYMBOL[_GPL] anywhere in the tree.  so does that mean
>>>> this feature can be tossed?  or might it still be used every so often?
>> it's one of those pieces of infrastructure that get used from time
>> to time to phase out symbol exports... we should be more agressive
>> about that; about 1/3rd of the exports is not used by anything in
>> linux, yet each symbol costs about 100 bytes of memory at runtime.
> 
> ok, so maybe its removal file entry should be deleted if it's going to
> hang around.  your call.
> 

the removal entry is/was for the symbols *marked*, not for the 
infrastructure....
