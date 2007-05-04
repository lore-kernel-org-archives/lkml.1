Return-Path: <linux-kernel-owner+w=401wt.eu-S1031708AbXEDVhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031708AbXEDVhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031711AbXEDVhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:37:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031708AbXEDVhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:37:33 -0400
Message-ID: <463BA772.9070203@redhat.com>
Date: Fri, 04 May 2007 18:36:50 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Organization: Red Hat Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
Subject: Re: [PATCH 00/40] Swap over Networked storage -v12
References: <20070504102651.923946304@chello.nl> <1178292179.7997.12.camel@imap.mvista.com>
In-Reply-To: <1178292179.7997.12.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Fri, 2007-05-04 at 12:26 +0200, Peter Zijlstra wrote:
>
>   
>> 1) introduce the memory reserve and make the SLAB allocator play nice with it.
>>    patches 01-10
>>
>> 2) add some needed infrastructure to the network code
>>    patches 11-13
>>
>> 3) implement the idea outlined above
>>    patches 14-20
>>
>> 4) teach the swap machinery to use generic address_spaces
>>    patches 21-24
>>
>> 5) implement swap over NFS using all the new stuff
>>    patches 25-31
>>
>> 6) implement swap over iSCSI
>>    patches 32-40
>>     
>
> This is kind of a lot of patches all at once .. Have you release any of
> these patch sets prior to this release ? 
>   

Yes, several times AFAIK.

- Arnaldo
