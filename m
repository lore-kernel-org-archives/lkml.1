Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088Ab0ATPJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab0ATPJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878Ab0ATPJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:09:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab0ATPJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:09:35 -0500
Message-ID: <4B571CAC.9000902@redhat.com>
Date: Wed, 20 Jan 2010 17:09:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: mtosatti@redhat.com, Davide Libenzi <davidel@xmailserver.org>,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] kvm: fix spurious interrupt with irqfd
References: <20100113171222.GA19798@redhat.com> <4B5305CA.5070001@redhat.com> <20100119145202.GC28465@redhat.com> <4B570EDD.6000808@redhat.com> <20100120145822.GB3434@redhat.com>
In-Reply-To: <20100120145822.GB3434@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 04:58 PM, Michael S. Tsirkin wrote:
>
>> I'm uncomfortable with pushing Davide's patch into stable and possibly
>> causing regressions with unrelated applications.  Can't a guest live
>> with a spurious interrupt?
>>      
> Well guests mask/unmask vector on each interrupt, so this will trigger
> an irq storm I think.
>
>    
>>   It's not like they're unknown.
>>      
> Depends on the device really.
> In theory, if they trigger at an unfortunate time this could cause
> crashes.
>
>    

I'd like confirmation on both of these before I push things to stable.

-- 
error compiling committee.c: too many arguments to function

