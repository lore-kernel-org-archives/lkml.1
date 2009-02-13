Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbZBMSxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbZBMSxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbZBMSwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:52:54 -0500
Received: from gw.goop.org ([64.81.55.164]:59936 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345AbZBMSwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:52:53 -0500
Message-ID: <4995C182.5040009@goop.org>
Date: Fri, 13 Feb 2009 10:52:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 headers: protect page_32.h via __ASSEMBLY__
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu> <20090213122325.GA30061@elte.hu> <20090213122724.GA2172@elte.hu> <20090213123721.GA1879@elte.hu> <4995BF9F.2050509@goop.org> <20090213184926.GA32338@elte.hu>
In-Reply-To: <20090213184926.GA32338@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>> From beb6943d8df7ce9278282101af4e0f6f7b648451 Mon Sep 17 00:00:00 2001
>>> From: Ingo Molnar <mingo@elte.hu>
>>> Date: Fri, 13 Feb 2009 13:36:47 +0100
>>> Subject: [PATCH] x86 headers: protect page_32.h via __ASSEMBLY__
>>>   
>>>       
>> I think this is wrong in principle.  There should never be a reason to  
>> include a non-_types.h into asm.
>>
>> (Fine as a build fix, of course.)
>>     
>
> Agreed - but it needs fixes to the .S files, these assembly files
> include pgtable.h or page.h:
>   

Piecemeal, or one sweep?

    J
