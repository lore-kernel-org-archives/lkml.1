Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZGAOqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZGAOqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZGAOq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:46:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34963 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZGAOq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:46:26 -0400
Message-ID: <4A4B76F3.6070604@redhat.com>
Date: Wed, 01 Jul 2009 17:47:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andi Kleen <ak@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, stable@kernel.org
Subject: Re: patch kvm-add-vt-x-machine-check-support.patch added to	2.6.30-stable
 tree
References: <20090629184144.76C9948FD3@coco.kroah.org> <200907010053.40900.s.L-H@gmx.de> <20090630234206.GA22546@suse.de> <4A4B0BB1.2010102@linux.intel.com> <4A4B11A6.6080402@redhat.com> <87d48kiliq.fsf@basil.nowhere.org> <4A4B67A2.9090300@redhat.com> <20090701141845.GW6760@one.firstfloor.org>
In-Reply-To: <20090701141845.GW6760@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2009 05:18 PM, Andi Kleen wrote:
> On Wed, Jul 01, 2009 at 04:41:54PM +0300, Avi Kivity wrote:
>    
>> Should be in struct vmx_vcpu; otherwise ack.
>>      
>
> Done
>
> ---
>
> KVM: Add VT-x machine check support v4
>
> VT-x needs an explicit MC vector intercept to handle machine checks in the
> hypervisor.
>
> It also has a special option to catch machine checks that happen
> during VT entry.
>
> Do these interceptions and forward them to the Linux machine check
> handler. Make it always look like user space is interrupted because
> the machine check handler treats kernel/user space differently.
>
> Thanks to Huang Ying and Jiang Yunhong for help and testing.
>
>    

Ack, thanks.  Stable boys, please use this instead of the patch from 
mainline and the two patches it dragged in.

-- 
error compiling committee.c: too many arguments to function

