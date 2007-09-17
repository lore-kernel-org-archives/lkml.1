Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbXIQJQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbXIQJQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbXIQJQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:16:25 -0400
Received: from il.qumranet.com ([82.166.9.18]:33666 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbXIQJQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:16:24 -0400
Message-ID: <46EE45C3.8040302@qumranet.com>
Date: Mon, 17 Sep 2007 11:15:47 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Nguyen Anh Quynh <aquynh@gmail.com>
Subject: Re: [PATCH 001/104] KVM: Fix *nopage() in kvm_main.c
References: <11900179463203-git-send-email-avi@qumranet.com> <11900179461472-git-send-email-avi@qumranet.com> <20070917091340.GB2083@infradead.org>
In-Reply-To: <20070917091340.GB2083@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Mon, 17 Sep 2007 11:15:47 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Sep 17, 2007 at 10:30:43AM +0200, Avi Kivity wrote:
>   
>> From: Nguyen Anh Quynh <aquynh@gmail.com>
>>
>> *nopage() in kvm_main.c should only store the type of mmap() fault if
>> the pointers are not NULL. This patch fixes the problem.
>>     
>
> Care to convert it to ->faul while you're at it?
>   

I'll add this to my todo, though not sure It'll be in time for .24.  If
someone sends a patch I'll apply it.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

