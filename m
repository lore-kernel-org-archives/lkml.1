Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYJXJXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYJXJXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYJXJW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:22:57 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:4372 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751586AbYJXJW5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:22:57 -0400
Message-ID: <49019307.6070207@tungstengraphics.com>
Date: Fri, 24 Oct 2008 11:19:03 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Keith Packard <keithp@keithp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, nickpiggin@yahoo.com.au,
       airlied@linux.ie, dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Peter Anvin <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org
Subject: Re: Adding kmap_atomic_prot_pfn
References: <20081020115810.GC10594@elte.hu> <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu> <1224793332.22877.8.camel@koto.keithp.com> <20081023133840.d4eef579.akpm@linux-foundation.org> <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org> <1224813015.22877.51.camel@koto.keithp.com> <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org> <1224829359.22877.86.camel@koto.keithp.com> <49017A2C.5010504@tungstengraphics.com> <20081024083830.GB6734@elte.hu>
In-Reply-To: <20081024083830.GB6734@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Thomas Hellström <thomas@tungstengraphics.com> wrote:
>
>   
>> Keith,
>>
>> What you actually are doing here is claiming copyright on code that 
>> other people have written, and tighten the export restrictions.  
>> kmap_atomic_prot_pfn() appeared long ago in drm git with identical 
>> code and purpose, but with different authors, and iounmap_atomic is 
>> identical to kunmap_atomic.
>>     
>
>   
>>> +EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
>>>       
>
> you want to use this facility in a binary-only driver?
>
> 	Ingo
>   
At this point I have no such use for it, no.
The original user was a MIT style licenced driver.

/Thomas



