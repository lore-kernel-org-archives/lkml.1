Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbZGGMZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbZGGMZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZGGMZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:25:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60283 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbZGGMZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:25:23 -0400
Message-ID: <4A533F45.90609@redhat.com>
Date: Tue, 07 Jul 2009 15:27:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com> <4A53372E.6090509@redhat.com> <20090707122250.GC3647@redhat.com>
In-Reply-To: <20090707122250.GC3647@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2009 03:22 PM, Michael S. Tsirkin wrote:
> On Tue, Jul 07, 2009 at 02:53:18PM +0300, Avi Kivity wrote:
>    
>>>> +		/* address-range must be precise for a hit */
>>>>
>>>>          
>>> So there's apparently no way to specify that
>>> you want 1,2, or 4 byte writes at address X?
>>>
>>>        
>> Why would you want that?
>>      
>
> Donnu. Why would anyone want to catch 8 byte writes at all?
>    

One of the natural write sizes.

> Seriously, why add artificial limitations?
> IMO, addr=0,len=1 and addr=0,len=2 should not conflict.
>
>    

They should not conflict, but a two byte write need not hit a one byte 
registration.

-- 
error compiling committee.c: too many arguments to function

