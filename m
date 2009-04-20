Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZDTM4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZDTM4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 08:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZDTM4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 08:56:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35091 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbZDTM4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 08:56:32 -0400
Message-ID: <49EC7005.7000909@redhat.com>
Date: Mon, 20 Apr 2009 15:52:21 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com
Subject: Re: [PATCH 5/5] add ksm kernel shared memory driver.
References: <1240191366-10029-1-git-send-email-ieidus@redhat.com>	<1240191366-10029-2-git-send-email-ieidus@redhat.com>	<1240191366-10029-3-git-send-email-ieidus@redhat.com>	<1240191366-10029-4-git-send-email-ieidus@redhat.com>	<1240191366-10029-5-git-send-email-ieidus@redhat.com>	<1240191366-10029-6-git-send-email-ieidus@redhat.com> <20090420110223.76ba4593@lxorguk.ukuu.org.uk> <49EC584B.3060809@redhat.com>
In-Reply-To: <49EC584B.3060809@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Alan Cox wrote:
>> The minor number you are using already belongs to another project.
>>
>> 10,234 is free but it would be good to know what device naming is
>> proposed. I imagine other folks would like to know why you aren't using
>> sysfs or similar or extending /dev/kvm ?
>>   
>
> ksm was deliberately made independent of kvm.  While there may or may 
> not be uses of ksm without kvm (you could run ordinary qemu, but no 
> one would do this in a production deployment), keeping them separate 
> helps avoid unnecessary interdependencies.  For example all tlb 
> flushes are mediated through mmu notifiers instead of ksm hooking 
> directly into kvm.
>
Yes, beside, I do use sysfs for controlling the ksm behavior,
Ioctls are provided as easier way for application to register its memory.
