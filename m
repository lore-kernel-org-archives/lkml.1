Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbZIMRQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbZIMRQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 13:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbZIMRQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 13:16:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:49787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbZIMRQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 13:16:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,379,1249282800"; 
   d="scan'208";a="493030626"
Message-ID: <4AAD28F2.3040606@intel.com>
Date: Sun, 13 Sep 2009 10:16:34 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "neilb@suse.de" <neilb@suse.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: Re: What's in async_tx.git/next for 2.6.32?
References: <4AA2BA83.5020707@intel.com> <20090914.013052.84972601.anemo@mba.ocn.ne.jp>
In-Reply-To: <20090914.013052.84972601.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> On Sat, 05 Sep 2009 12:22:43 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
>> Provided Neil and Peter provide their acks for the raid6 acceleration 
>> work, here is what is pending in async_tx.git/next for 2.6.32:
> ...
>>     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next
>>
>> Dan Williams (67):
> ...
>>        dw_dmac: implement a private tx_list
>>        fsldma: implement a private tx_list
>>        iop-adma: implement a private tx_list
>>        ioat: implement a private tx_list
>>        mv_xor: implement a private tx_list
>>        at_hdmac: implement a private tx_list
>>        dmaengine: kill tx_list
> 
> Could you implement a private tx_list for txx9dmac too?

I noticed that too when I merged with -next.  I forgot to send this [1] out.

Thanks,
Dan

[1]: 
http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=commitdiff;h=1979b186b80449ac6574d97c254b694c8a99b703
