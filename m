Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYGQGm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYGQGm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYGQGmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:42:19 -0400
Received: from il.qumranet.com ([212.179.150.194]:57745 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbYGQGmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:42:18 -0400
Message-ID: <487EE9C9.2050108@qumranet.com>
Date: Thu, 17 Jul 2008 09:42:17 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
Subject: Re: KVM overflows the stack
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>	 <47EA1C63.8010202@qumranet.com>	 <1206550329.7883.5.camel@nimitz.home.sr71.net>	 <47EA80AC.4070204@qumranet.com>	 <1206551794.7883.7.camel@nimitz.home.sr71.net>	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>	 <1206629709.7883.30.camel@nimitz.home.sr71.net>	 <47EBB63E.2060306@qumranet.com>	 <1212445810.8211.9.camel@nimitz.home.sr71.net>	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>	 <48512028.3070104@qumranet.com>  <1216148242.25942.6.camel@nimitz>	 <1216244660.8711.6.camel@nimitz> <1216248527.11664.9.camel@nimitz>	 <487EDE26.8040201@qumranet.com> <1216275288.11664.13.camel@nimitz>
In-Reply-To: <1216275288.11664.13.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
>   
>> switch (...) {
>>     case x: {
>>          struct medium a;
>>          ...
>>     }
>>     case y:
>>           struct medium b;
>>           ...
>>     }
>> };
>>
>> These could be solved either by stack allocation, or by moving into 
>> functions marked noinline.  Whichever is easier.
>>     
>
> Did you mean dynamic allocation? :)
>
>   

Yeah.  Too early in the morning for me.

Roland's trick might be easier than either, though.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

