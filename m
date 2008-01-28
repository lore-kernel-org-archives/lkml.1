Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbYA1WeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbYA1WeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYA1WeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:34:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbYA1Wd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:33:59 -0500
Message-ID: <479E5835.7000803@redhat.com>
Date: Tue, 29 Jan 2008 09:33:25 +1100
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Marcelo Tosatti <marcelo@kvack.org>, ehabkost@redhat.com,
       glommer@gmail.com, jeremy@goop.org, chrisw@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fill in missing pv_mmu_ops entries for	PAGETABLE_LEVELS
 >= 3
References: <12006768251548-git-send-email-gcosta@redhat.com> <20080119181909.GA4640@dmt> <20080122123029.GD31253@elte.hu>
In-Reply-To: <20080122123029.GD31253@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Marcelo Tosatti <marcelo@kvack.org> wrote:
>
>   
>>> The first fix is not even specific for PARAVIRT, and it's actually 
>>> preventing the whole tree from booting.
>>>
>>>       
>> And the following allows PARAVIRT kernels to boot on x86_64.
>>     
>
>   
>> Fill in missing pagetable manipulation entries in pv_mmu_ops 
>> for PAGETABLE_LEVELS >= 3.
>>     
>
> thanks Marcelo - picked this up and the other changes as well. I guess 
> the only thing missing at the moment is the proper Kconfig changes to 
> allow the building of a 64-bit PARAVIRT kernel?
> 	Ingo
>   
For normal hardware yes. But I still have a vsmp patch in the queue.
