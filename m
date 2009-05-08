Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbZEHIhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbZEHIhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZEHIhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:37:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZEHIhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:37:05 -0400
Message-ID: <4A03EEDA.5090008@redhat.com>
Date: Fri, 08 May 2009 11:35:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com> <4A032A74.2020809@novell.com> <4A032FDD.8020209@redhat.com> <4A033101.8050106@gmail.com> <4A0339D2.3050600@redhat.com> <4A033F6E.3010604@novell.com> <4A03416D.8020405@redhat.com> <4A0343F5.5070509@gmail.com>
In-Reply-To: <4A0343F5.5070509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:

    

>>> Ack.  I hope when its all said and done I can convince you that the
>>> framework to code up those virtio backends in the kernel is vbus ;)
>>>       
>> If vbus doesn't bring significant performance advantages, I'll prefer
>> virtio because of existing investment.
>>     
>
> Just to clarify: vbus is just the container/framework for the in-kernel
> models.  You can implement and deploy virtio devices inside the
> container (tho I haven't had a chance to sit down and implement one
> yet).  Note that I did publish a virtio transport in the last few series
> to demonstrate how that might work, so its just ripe for the picking if
> someone is so inclined.
>
>   

Yeah I keep getting confused over this.

> So really the question is whether you implement the in-kernel virtio
> backend in vbus, in some other framework, or just do it standalone.
>   

I prefer the standalone model.  Keep the glue in userspace.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

