Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbXIQJTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbXIQJTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbXIQJTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:19:37 -0400
Received: from il.qumranet.com ([82.166.9.18]:41938 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbXIQJTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:19:36 -0400
Message-ID: <46EE4683.7070205@qumranet.com>
Date: Mon, 17 Sep 2007 11:18:59 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Nguyen Anh Quynh <aquynh@gmail.com>
Subject: Re: [PATCH 001/104] KVM: Fix *nopage() in kvm_main.c
References: <11900179463203-git-send-email-avi@qumranet.com> <11900179461472-git-send-email-avi@qumranet.com> <20070917091340.GB2083@infradead.org> <46EE45C3.8040302@qumranet.com>
In-Reply-To: <46EE45C3.8040302@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Mon, 17 Sep 2007 11:18:59 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Christoph Hellwig wrote:
>   
>> On Mon, Sep 17, 2007 at 10:30:43AM +0200, Avi Kivity wrote:
>>   
>>     
>>> From: Nguyen Anh Quynh <aquynh@gmail.com>
>>>
>>> *nopage() in kvm_main.c should only store the type of mmap() fault if
>>> the pointers are not NULL. This patch fixes the problem.
>>>     
>>>       
>> Care to convert it to ->faul while you're at it?
>>   
>>     
>
> I'll add this to my todo, though not sure It'll be in time for .24.  If
> someone sends a patch I'll apply it.
>
>   

I should mention that the converting to use ->fault() is a 15-minute
change; the tricky part is adding backwards compatibility for the
external module package.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

