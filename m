Return-Path: <linux-kernel-owner+w=401wt.eu-S933603AbXK3OKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbXK3OKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 09:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbXK3OKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 09:10:08 -0500
Received: from venus.billgatliff.com ([209.251.101.201]:40700 "EHLO
	venus.billgatliff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbXK3OKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 09:10:06 -0500
Message-ID: <475019B4.1090603@billgatliff.com>
Date: Fri, 30 Nov 2007 08:09:56 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>, Tony Lindgren <tony@atomide.com>,
       eric miao <eric.y.miao@gmail.com>, Kevin Hilman <khilman@mvista.com>,
       Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben@trinity.fluff.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
References: <200710291809.29936.david-b@pacbell.net>	<200710291851.49057.david-b@pacbell.net>	<20071130133256.72385ea8@hyperion.delvare>	<47500A4A.10006@billgatliff.com> <20071130143654.3fd39ffe@hyperion.delvare>
In-Reply-To: <20071130143654.3fd39ffe@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Bill,
>
> On Fri, 30 Nov 2007 07:04:10 -0600, Bill Gatliff wrote:
>   
>> Jean Delvare wrote:
>>     
>>> !!(value & (1 << offset))
>>> is more efficiently written
>>> (value >> offset) & 1
>>>       
>> ... but not more efficiently implemented.
>>
>> Your version requires code to do the shift on live data at runtime.  
>> David's version lets the compiler create the mask once, at compile-time.
>>     
>
> I don't understand. How could the compiler create the mask at
> compile-time when "offset" is only known at runtime?
>   

Oops.  :)  I was thinking of some different code.  Disregard.

/me got up too early this morning, after working too late last night!


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

