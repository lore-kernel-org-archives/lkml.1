Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZDVQRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZDVQRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZDVQR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:17:29 -0400
Received: from static-88-194-224-77.ipcom.comunitel.net ([77.224.194.88]:55563
	"EHLO panicking.kicks-ass.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbZDVQR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:17:28 -0400
X-Greylist: delayed 4460 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 12:17:28 EDT
Message-ID: <49EF4201.9030606@evidence.eu.com>
Date: Wed, 22 Apr 2009 18:12:49 +0200
From: michael <michael@evidence.eu.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
CC: Roland Dreier <rdreier@cisco.com>, fenkes@de.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, OF-EWG <ewg@lists.openfabrics.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>, raisch@de.ibm.com,
       alexschm@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: [PATCH 1/3] IB/ehca: Replace vmalloc with kmalloc
References: <200904211716.45245.ossrosch@linux.vnet.ibm.com>	<200904221602.29028.ossrosch@linux.vnet.ibm.com>	<49EF254A.6020106@evidence.eu.com> <200904221800.41399.ossrosch@linux.vnet.ibm.com>
In-Reply-To: <200904221800.41399.ossrosch@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stefan Roscher wrote:
> On Wednesday 22 April 2009 04:10:18 pm michael wrote:
>   
>> Hi,
>>
>>     
>
>   
>> I don't take the point, if it is not import use the vmalloc. Why you try 
>> with a kmalloc
>> alloc first? and why do not use kzalloc?
>>     
>
> Because kmalloc() is faster than vmalloc() causing a huge performance win
> when someone allocates a large number of queue pairs. We fall back to
> vmalloc() only if kmalloc() can't deliver the memory chunk.
>   
Sorry I catch later the performace issue.
> We don't need kzalloc because we fill the list right after the alloc.
>
> regards Stefan
>   
Regards Michael
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
>
>   

