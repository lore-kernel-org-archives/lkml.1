Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbZGHTqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbZGHTqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbZGHTp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:45:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46287 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbZGHTpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:45:55 -0400
Message-ID: <4A54F77B.80008@redhat.com>
Date: Wed, 08 Jul 2009 22:46:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: ioctl return value fix
References: <20090620192941.GA26873@lst.de> <200906231643.10623.rusty@rustcorp.com.au> <20090708181220.GB10552@lst.de>
In-Reply-To: <20090708181220.GB10552@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2009 09:12 PM, Christoph Hellwig wrote:
> On Tue, Jun 23, 2009 at 04:43:10PM +0930, Rusty Russell wrote:
>    
>> On Sun, 21 Jun 2009 04:59:41 am Christoph Hellwig wrote:
>>      
>>> Block driver ioctl methods must return ENOTTY and not -ENOIOCTLCMD if
>>> they expect the block layer to handle generic ioctls.
>>>
>>> This triggered a BLKROSET failure in xfsqa #200.
>>>        
>> Applied.
>>      
>
> Can you send on this fix to Linus?  It fixes a regression introduced in
> Linux 2.6.30.
>
>    

It should set the Cc: stable@kernel.org marker then.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

