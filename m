Return-Path: <linux-kernel-owner+w=401wt.eu-S1762711AbYCVCla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762711AbYCVCla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbYCVCi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:38:57 -0400
Received: from gw.goop.org ([64.81.55.164]:40003 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbYCVCiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:38:55 -0400
Message-ID: <47E4701B.6060203@goop.org>
Date: Fri, 21 Mar 2008 19:34:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
References: <47E18B8E.8080104@goop.org> <20080319220028.GA10480@elte.hu> <47E18C9D.4010007@goop.org> <20080319220431.GA11606@elte.hu> <47E19085.2020308@goop.org> <20080319235212.GA22786@elte.hu> <47E2C7E3.40109@goop.org> <20080321131738.GI27245@elte.hu> <20080321143533.GA32096@elte.hu> <47E3D0FE.2030508@goop.org> <20080321152555.GA14607@elte.hu>
In-Reply-To: <20080321152555.GA14607@elte.hu>
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
>>> it just crashed again, crashlog and config attached. This time it 
>>> didnt need an irq flood.
>>>       
>> Hm.  I presume it happens immediately/consistently.  Is it something 
>> particular about this .config?  Do other configs work for you?
>>     
>
> it's a generic distro config this time around. It crashed on the first 
> attempt.

I haven't had a chance to try this on real hardware yet, but could you 
confirm that booting with "nosep" avoids the problem?  If not, then some 
deep voodoo is going on...

Thanks,
    J
