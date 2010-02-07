Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab0BGJ46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 04:56:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab0BGJ45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 04:56:57 -0500
Message-ID: <4B6E8E3E.30705@redhat.com>
Date: Sun, 07 Feb 2010 11:56:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] vhost-net: switch to smp barriers
References: <20100201172101.GA10900@redhat.com> <4B6E8B05.8070607@redhat.com> <20100207094441.GA20271@redhat.com>
In-Reply-To: <20100207094441.GA20271@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2010 11:44 AM, Michael S. Tsirkin wrote:
> On Sun, Feb 07, 2010 at 11:42:29AM +0200, Avi Kivity wrote:
>    
>> On 02/01/2010 07:21 PM, Michael S. Tsirkin wrote:
>>      
>>> vhost-net only uses memory barriers to control SMP effects
>>> (communication with userspace potentially running on a different CPU),
>>> so it should use SMP barriers and not mandatory barriers for memory
>>> access ordering, as suggested by Documentation/memory-barriers.txt
>>>
>>>
>>>        
>> A UP guest running on an SMP host still needs those barriers.
>>      
> Correct. And since vhost net is running host-side, smp_XX
> barriers will do exactly the right thing, right?
>    

Right, of course.  Mixed up virtio and vhost.

-- 
error compiling committee.c: too many arguments to function

