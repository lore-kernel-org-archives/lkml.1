Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbZBETIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbZBETIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZBETIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:08:32 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:47422 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZBETIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:08:31 -0500
Message-ID: <498B3913.2010701@codemonkey.ws>
Date: Thu, 05 Feb 2009 13:08:03 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, akataria@vmware.com,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH 1/2] show hypervisor information on cpuinfo
References: <1233859341-10419-1-git-send-email-glommer@redhat.com> <1233859341-10419-2-git-send-email-glommer@redhat.com> <20090205190250.GE20470@elte.hu>
In-Reply-To: <20090205190250.GE20470@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Glauber Costa <glommer@redhat.com> wrote:
>
>   
>> +char * __cpuinit hypervisor_str(struct cpuinfo_x86 *c)
>> +{
>> +	if (c->x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
>> +		return "VMWare";
>> +	else
>> +		return "none";
>> +}
>>     
>
> i'd suggest these variants instead:
>
>  virtualization:	native kernel
>   

I don't think "native kernel" really ports well to other architectures 
(like s390 or PPC) that always have hypervisors present in some form.  I 
think "none" makes more sense in the case of bare metal x86.

Regards,

Anthony Liguori

>  virtualization:	KVM guest
>  virtualization:	VMWare guest
>  virtualization:	Linux guest
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

