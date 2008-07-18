Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbYGRQI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbYGRQI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbYGRQIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:08:42 -0400
Received: from gw.goop.org ([64.81.55.164]:33669 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbYGRQIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:08:41 -0400
Message-ID: <4880BFFC.9060108@goop.org>
Date: Fri, 18 Jul 2008 09:08:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH] x86: clean up pgd_{c,d}tor
References: <4880AD11.76E4.0078.0@novell.com> <4880AE15.5060101@goop.org> <4880D1A0.76E4.0078.0@novell.com>
In-Reply-To: <4880D1A0.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Jeremy Fitzhardinge <jeremy@goop.org> 18.07.08 16:52 >>>
>>>>         
>> Jan Beulich wrote:
>>     
>>> Giving pgd_ctor() a properly typed parameter allows eliminating a local
>>> variable. Adjust pgd_dtor() to match.
>>>
>>> Also, pgd_ctor()'s clearing of the memory is redundant with the
>>> GFP_ZERO used for allocating it.
>>>   
>>>       
>> Ack to the parameter type change.  But there's already a patch in git to 
>> remove the redundant clear.
>>     
>
> Again, I can't see this in my just refreshed tree - am I doing things wrong?
> Or is this due to the myriads of topic branches (which of course I don't
> check out all)?
>   

No, the changes are in mainline linux-2.6.git, though you should be able 
to find them in master in tip.git.

    J

