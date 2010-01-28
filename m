Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425Ab0A1W66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0A1W66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653Ab0A1W65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:58:57 -0500
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:42588 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab0A1W64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:58:56 -0500
Date: Thu, 28 Jan 2010 17:59:05 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Hang: 2.6.32.4 sky2/DMAR (was [PATCH] sky2: Fix WARNING: at
 lib/dma-debug.c:902 check_sync)
In-reply-to: <20100128225621.GD3109@del.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Message-id: <4B6216B9.1010802@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B60707F.1000608@majjas.com> <20100127095614.14313677@nehalam>
 <4B608128.7090607@majjas.com> <4B6089C7.4010803@majjas.com>
 <4B61ADF1.7060705@majjas.com> <4B61BEA4.1030905@majjas.com>
 <20100128090835.0d93e53a@nehalam> <4B61DB79.4080703@majjas.com>
 <20100128223447.GC3109@del.dom.local> <4B621316.8070308@majjas.com>
 <20100128225621.GD3109@del.dom.local>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/2010 5:56 PM, Jarek Poplawski wrote:
> On Thu, Jan 28, 2010 at 05:43:34PM -0500, Michael Breuer wrote:
>    
>> This is with the pci_unmap_len patch as well as the dma-debug patch.
>> I'm not getting any warnings - but dma-debug num-free-entries drops
>> until zero and then debugging is disabled. I started with 8,000,000
>> about three hours ago - without load I'm already down to less than
>> half that. Again - only looking at sky2. Looks like the dma-debug
>> hash table is reducing one entry for every packet, but never
>> increasing the num_entries (no unmap perhaps).
>>      
> OK, then, until there is some new fix you better turn it off.
>
> Jarek P.
>    
:( any further suggestions for helping track this down?
