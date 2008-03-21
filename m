Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYCUPTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYCUPTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYCUPTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:19:14 -0400
Received: from gw.goop.org ([64.81.55.164]:38020 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbYCUPTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:19:13 -0400
Message-ID: <47E3D0FE.2030508@goop.org>
Date: Fri, 21 Mar 2008 08:15:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
References: <20080319200931.GA24828@elte.hu> <20080319213343.GA2195@elte.hu> <47E18B8E.8080104@goop.org> <20080319220028.GA10480@elte.hu> <47E18C9D.4010007@goop.org> <20080319220431.GA11606@elte.hu> <47E19085.2020308@goop.org> <20080319235212.GA22786@elte.hu> <47E2C7E3.40109@goop.org> <20080321131738.GI27245@elte.hu> <20080321143533.GA32096@elte.hu>
In-Reply-To: <20080321143533.GA32096@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>>> Hm.  I think the problem was that the patch changed the ordering so 
>>> that the %ebp fault test was happening with interrupts disabled, 
>>> meaning that any fault-in would happen with interrupts disabled.
>>>
>>> Could you tell me if this revised patch still provokes a problem?
>>>       
>> it's looking good so far - queued it up.
>>     
>
> it just crashed again, crashlog and config attached. This time it didnt 
> need an irq flood.
>   

Hm.  I presume it happens immediately/consistently.  Is it something 
particular about this .config?  Do other configs work for you?

Thanks,
    J
