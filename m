Return-Path: <linux-kernel-owner+w=401wt.eu-S1762756AbZC0ANc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756AbZC0ANc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbZC0ALW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:11:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55905 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbZC0ALU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:11:20 -0400
Message-ID: <49CC195A.8060100@zytor.com>
Date: Thu, 26 Mar 2009 17:10:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: akataria@vmware.com
CC: "david@lang.hm" <david@lang.hm>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: move vmware to hypervisor
References: <1237281581.7907.2.camel@ht.satnam>	 <20090317093919.GD6477@elte.hu> <1237283318.7907.9.camel@ht.satnam>	 <49BFC6CB.9070603@zytor.com>	 <1237958994.5556.5.camel@localhost.localdomain>	 <20090325125955.GB516@elte.hu>  <1237999971.32497.12.camel@alok-dev1>	 <1238000840.2500.49.camel@ht.satnam>  <1238001853.32497.22.camel@alok-dev1>	 <1238002693.2500.52.camel@ht.satnam> <1238005127.32497.38.camel@alok-dev1>	 <alpine.DEB.1.10.0903260008050.13440@asgard.lang.hm> <1238085621.21971.3.camel@alok-dev1>
In-Reply-To: <1238085621.21971.3.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
>>>>
>>> So, if there are any tangible benefits with doing this I am ok with it,
>>> but your current argument about "Freedom to user"  doesn't sound too
>>> compelling.
>> isn't it the other way around? you are adding this in, it should be up to 
>> you to show that it
>>
>> A. has no impact
>>
>> B. has a small enough impact that it's not worth the config option
> 
> This is what exactly I have mentioned in a mail earlier in this thread.
> http://lkml.org/lkml/2009/3/25/333
> 

It sounds to me like the kind of things that gets buried under 
CONFIG_EMBEDDED for the people who are absolutely paranoid (sometimes 
even for very good reasons) about every additional byte in the kernel.

	-hpa
