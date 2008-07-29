Return-Path: <linux-kernel-owner+w=401wt.eu-S1759270AbYG2SqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbYG2SqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYG2Sp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:45:58 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59860 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754270AbYG2Sp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:45:57 -0400
Message-ID: <488F6563.4000907@sgi.com>
Date: Tue, 29 Jul 2008 11:45:55 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Cliff Wickman <cpw@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, steiner@sgi.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Comments on UV tlb flushing
References: <488E644B.10801@goop.org>	 <200807291412.18495.nickpiggin@yahoo.com.au>	 <20080729133204.GA13138@sgi.com> <488F2C9B.9070306@goop.org> <86802c440807291113u59ba996dg340c8feba1039f3a@mail.gmail.com> <488F60A1.2080902@goop.org>
In-Reply-To: <488F60A1.2080902@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
>> On Tue, Jul 29, 2008 at 7:43 AM, Jeremy Fitzhardinge <jeremy@goop.org>
>> wrote:
>>  
>>> Cliff Wickman wrote:
>>>    
>>>> I think that the Linux distributions are not going to build a special
>>>> UV kernel, are they?  So every distro would have to be prompted to
>>>> turn on
>>>> CONFIG_X86_UV, or else their kernel is not going to boot on UV.
>>>>
>>>>       
>>> Distros will generally turn on everything.  You could have it on by
>>> default
>>> if the kernel is built for CONFIG_X86_GENERICARCH which enables
>>> support for
>>> other big numa configurations.  I think distros generally build with
>>> that
>>> enabled anyway.
>>>     
>>
>> config X86_GENERICARCH
>>        bool "Generic architecture"
>>         depends on X86_32
>>   
> 
> Ah, overlooked that.
> 
> OK, well, either way it still needs to be a separate config option.
> 
>    J

Should there be a "generic" X86_ENTERPRISE_ARCH which turns on various
capabilities?  Our licenses and support agreements with SuSE and RH are
for their "Enterprise Editions" though the customer is free to run
whatever (unsupported from us).  Asking distros to enable that option
should be a no-brainer.  And it could be defaulted ON with the comment
to turn it off if you have a small desktop system.  This way they won't
forget... ;-)  [Actually, this could turn on MAXSMP as well.]

Thanks,
Mike
