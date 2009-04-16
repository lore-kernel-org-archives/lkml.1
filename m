Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZDPNZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZDPNZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbZDPNYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:24:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:30762 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZDPNYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:24:51 -0400
Message-ID: <49E731B6.5050706@billgatliff.com>
Date: Thu, 16 Apr 2009 08:25:10 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: Ben Nizette <bn@niasdigital.com>, imre.deak@nokia.com,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [REGRESSION] threaded interrupt handler support breaks (some)
 irq handling on AVR32
References: <1239685153.19815.12.camel@linux-51e8.site>	<1239698225.29831.14.camel@linux-51e8.site>	<1239759053.29831.37.camel@linux-51e8.site>	<20090415095710.5c853a7f@hskinnemoen-d830>	<20090415103352.5ee43824@hskinnemoen-d830>	<49E604DB.9070702@billgatliff.com> <20090416104045.5ff940e2@hskinnemoen-d830>
In-Reply-To: <20090416104045.5ff940e2@hskinnemoen-d830>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> Bill Gatliff wrote:
>   
>> Haavard Skinnemoen wrote:
>>     
>>> AFAICT, this code has always been dangerous.
>>>     
>>>       
>> Can you propose a better way to handle the problem?  It's a case that 
>> crops up with a lot of touch screen controllers.
>>     
>
> I thought I already did: Use disable_irq_nosync() instead.
>   

Aah.  I misinterpreted what you wrote.  Thanks!


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

