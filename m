Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZGGMyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZGGMyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbZGGMyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:54:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36669 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039AbZGGMyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:54:22 -0400
Message-ID: <4A534611.8010409@redhat.com>
Date: Tue, 07 Jul 2009 15:56:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com> <4A53372E.6090509@redhat.com> <20090707122250.GC3647@redhat.com> <4A533F45.90609@redhat.com> <20090707125148.GE3647@redhat.com>
In-Reply-To: <20090707125148.GE3647@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2009 03:51 PM, Michael S. Tsirkin wrote:
>
>>> Seriously, why add artificial limitations?
>>> IMO, addr=0,len=1 and addr=0,len=2 should not conflict.
>>>
>>>
>>>        
>> They should not conflict, but a two byte write need not hit a one byte
>> registration.
>>      
>
> Yes. That's exactly what I'm saying. I think it should be possible to
> create 2 fds:
>
> addr = 0
> len = 1
> addr = 0
> len = 2
> and at most one will ever trigger.
>
> But current code will not let you create the second one.
>    

I agree then.  Good catch.

-- 
error compiling committee.c: too many arguments to function

