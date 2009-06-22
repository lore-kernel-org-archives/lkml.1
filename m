Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbZFVO17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbZFVO17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZFVO1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:27:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49816 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbZFVO1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:27:48 -0400
Message-ID: <4A3F9515.3080200@redhat.com>
Date: Mon, 22 Jun 2009 17:28:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <gregory.haskins@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622104435.GA11594@redhat.com> <4A3F757C.6030508@novell.com> <20090622123022.GC12867@redhat.com> <4A3F8170.7000508@gmail.com> <20090622131351.GE12867@redhat.com>
In-Reply-To: <20090622131351.GE12867@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2009 04:13 PM, Michael S. Tsirkin wrote:
>> Right, understood.  What I meant specifically is that if the (void*)val
>> pointer is allowed to be misaligned we are in trouble ;).  I haven't
>> studied the implementation in front of the MMIO callback recently, but I
>> generally doubt thats the case.  More than likely this is some buffer
>> that was kmalloced and that should already be aligned to the machine word.
>>
>> Kind Regards,
>> -Greg
>>
>>      
>
> Yes, from what I saw of the code I think it can be BUG_ON.
> Avi?
>    

Yes, BUG_ON is safe here.

-- 
error compiling committee.c: too many arguments to function

