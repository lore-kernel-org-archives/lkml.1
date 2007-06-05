Return-Path: <linux-kernel-owner+w=401wt.eu-S1763610AbXFEIzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763610AbXFEIzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762077AbXFEIy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:54:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:28139 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbXFEIy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:54:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=SE3yi710sGfvygfNRCJbEfUFL4dnK4W9bj7fIEmKjs5Xi0/bzF0OZFsMfytrPgzvXGxPnHIZYGIcXBJ+7VPy9YBj4sOFIbcNJFzbMES1jpyKNwhRtr7qLpYgy0cAC0uVx99wpnijCPO7h0BBUuNa2hnINk+VuLGZVg/PF2/4V4w=
Message-ID: <466524D3.7060806@gmail.com>
Date: Tue, 05 Jun 2007 16:54:43 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v14
References: <20070523120616.GA23407@elte.hu> <4658F1D6.3070706@gmail.com> <20070529061544.GA28523@elte.hu> <20070529080738.GA28657@elte.hu> <465E992C.4020601@gmail.com> <20070531095337.GA8104@elte.hu> <465FC7E7.7080804@gmail.com> <20070601192142.GA10039@elte.hu> <4664CB6D.8060507@gmail.com> <20070605080130.GA4301@elte.hu>
In-Reply-To: <20070605080130.GA4301@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Yu <raise.sail@gmail.com> wrote:
>
>   
>> Eh, I wrong again~ I even took an experiment in last week end, this 
>> idea is really bad! ;(
>>
>> I think the most inner of source of my wrong again and again is 
>> misunderstanding virtual time. For more better understanding this, I 
>> try to write one python script to simulate CFS behavior. However, It 
>> can not implement the fairness as I want. I really confuse here.
>>
>> Would you like help me point out what's wrong in it? Any suggestion is 
>> welcome. Thanks in advanced.
>>     
>
> sorry, my python-fu is really, really weak. All i can give you at the 
> moment is the in-kernel implementation of CFS :-)
>
>   
:~)

I changed that script to check my understanding of virtual clock. I 
found out we really got the really fairness if allocate resource by 
selecting the most earliest task virtual clock! this really eliminate my 
doubt on virtual clock in much degree. for example:

./htucfs.py 60

==============================
TASK_1/C10.00 / 1.0 : 11.0 sec
TASK_2/C10.00 / 2.0 : 20.0 sec
TASK_3/C10.00 / 3.0 : 30.0 sec
==============================

It seem my haltingly english works fine when I read the introduction of 
virtual clock ;-)

The next step is find out why wait_runtime can not work normally in my 
script. 

Thanks for your quickly reply.

Good luck.

- Li Yu
