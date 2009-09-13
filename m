Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbZIMRbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbZIMRbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 13:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbZIMRbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 13:31:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:28650 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbZIMRbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 13:31:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,379,1249282800"; 
   d="scan'208";a="448125615"
Message-ID: <4AAD2C7F.2080904@intel.com>
Date: Sun, 13 Sep 2009 10:31:43 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: Re: dca: module load should not be an error message
References: <20090913090737.3141c842@nehalam>
In-Reply-To: <20090913090737.3141c842@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> The message (if it must exist) should not be an error message.
> IMHO such messages are useless.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> ---
> I sent patch for this previously, but it seems to have been ignored.
> 

Sorry about that... applied now.  There are a couple other messages in 
drivers/dma/ioat/dca.c and drivers/dma/ioat/pci.c that can also be 
de-clawed.  I'll take care of those.

Thanks,
Dan

