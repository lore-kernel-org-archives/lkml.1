Return-Path: <linux-kernel-owner+w=401wt.eu-S1750704AbXBVKO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750704AbXBVKO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbXBVKO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:14:59 -0500
Received: from il.qumranet.com ([82.166.9.18]:49333 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbXBVKO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:14:59 -0500
Message-ID: <45DD6CF0.3010509@qumranet.com>
Date: Thu, 22 Feb 2007 12:14:08 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@osdl.org, mingo@elte.hu
Subject: Re: [PATCH 10/13] KVM: Wire up hypercall handlers to a central arch-independent
 location
References: <45D979D3.2020907@qumranet.com> <20070219103052.4D23725016B@il.qumranet.com> <20070221103733.GI3945@ucw.cz>
In-Reply-To: <20070221103733.GI3945@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Mon 2007-02-19 10:30:52, Avi Kivity wrote:
>   
>> Signed-off-by: Avi Kivity <avi@qumranet.com>
>>     
>
> changelog?
>
>   

Well, I can't think of anything to add beyond $subject.  The patch adds 
calls from the arch-dependent hypercall handlers to a new arch 
independent function.


>> +	switch (nr) {
>> +	default:
>> +		;
>> +	}
>>     
>
> Eh?
>
>   

No hypercalls defined yet.


-- 
error compiling committee.c: too many arguments to function

