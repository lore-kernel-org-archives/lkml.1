Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbZHWNBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbZHWNBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933540AbZHWNBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:01:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531AbZHWNBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:01:31 -0400
Message-ID: <4A913DA9.1020403@redhat.com>
Date: Sun, 23 Aug 2009 16:01:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com> <20090820175540.GA9232@redhat.com> <4A8D90BB.2030506@redhat.com> <20090820182847.GB9282@redhat.com>
In-Reply-To: <20090820182847.GB9282@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 09:28 PM, Michael S. Tsirkin wrote:
>>> I thought the point was to move assigned devices out of KVM?
>>>
>>>        
>> Grr.  Forgot about that.
>>
>> That's much more important.
>>      
> Looks like we'll have do with a separate char device or
> something?
>    

We can still tunnel it through userspace.  Most assigned devices will 
have MSI.  uio can signal the eventfd when the level changes, qemu can 
read the level and write it to kvm.

-- 
error compiling committee.c: too many arguments to function

