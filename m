Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZGLIp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZGLIp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZGLIpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:45:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35767 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZGLIpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:45:15 -0400
Message-ID: <4A59A346.5040305@redhat.com>
Date: Sun, 12 Jul 2009 11:48:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [KVM PATCH v10 2/2] KVM: add ioeventfd support
References: <20090707210023.21953.22087.stgit@dev.haskins.net> <20090707210849.21953.93817.stgit@dev.haskins.net> <4A56060C.4090206@gmail.com>
In-Reply-To: <4A56060C.4090206@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2009 06:00 PM, Gregory Haskins wrote:
>
>> +		bool wildcard = args->flags&  KVM_IOEVENTFD_FLAG_DATAMATCH ?
>> +			true : false;
>>
>>      
> Doh!  Inverted logic.  "wildcard" should be "false" if DATAMATCH is
> defined in the flags.
>
> Avi, please reverse true/false here before accepting (assuming a v11
> respin isn't needed).  Of course, if you would prefer me to just submit
> a new patch, that is fine too.
>
>    

I changed it to !(...).  I find the predicate ? true : false idiom 
confusing.

-- 
error compiling committee.c: too many arguments to function

