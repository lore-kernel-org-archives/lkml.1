Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbZKSQNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbZKSQNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZKSQNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:13:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbZKSQNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:13:50 -0500
Message-ID: <4B056EB8.9020509@redhat.com>
Date: Thu, 19 Nov 2009 18:13:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Adam Litke <agl@us.ibm.com>
CC: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, qemu-devel@nongnu.org,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: virtio: Add memory statistics reporting to the balloon driver
 (V3)
References: <1258643169.3464.3.camel@aglitke>	 <1258643945.3464.5.camel@aglitke>  <4B0562A0.7040507@redhat.com> <1258646331.3464.18.camel@aglitke>
In-Reply-To: <1258646331.3464.18.camel@aglitke>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2009 05:58 PM, Adam Litke wrote:
> On Thu, 2009-11-19 at 17:22 +0200, Avi Kivity wrote:
>    
>> On 11/19/2009 05:19 PM, Adam Litke wrote:
>>      
>>> Rusty and Anthony,
>>> If I've addressed all outstanding issues, please consider this patch for
>>> inclusion.  Thanks.
>>>
>>> +struct virtio_balloon_stat
>>> +{
>>> +	__le16 tag;
>>> +	__le64 val;
>>> +};
>>> +
>>>
>>>        
>> You're not doing endian conversion in the host?
>>      
> No.  I was following by example.  For the virtio_balloon, the existing
> code is careful so that the guest always writes data in little endian.
>    

I don't follow.  If the guest is careful to write little-endian, surely 
the host must be equally careful to read little-endian?

-- 
error compiling committee.c: too many arguments to function

