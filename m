Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZLJHFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZLJHFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZLJHFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:05:11 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:47999 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbZLJHFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:05:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KjWofUcyQA96N5ryn1Rjd3oGLotX5Di2sXUMJTxMqcv0TamFq/BTzn+tgMC5Q09kSi
         toVcunRRI9n3HBlKGfKiKys8uG1JUYLy5NkMTqncy/Zlgbp1OUFDYazxVqraluNGYpTJ
         ZjmutEKGliPi46zZmrzarTNln+iMxbjdJBWpM=
Message-ID: <4B209D90.6080404@gmail.com>
Date: Thu, 10 Dec 2009 15:04:48 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 2.6.33] V4L/DVB updates
References: <20091209021639.14f08856@pedra> <20091210062015.GA29594@elte.hu>
In-Reply-To: <20091210062015.GA29594@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Hi,
> 
> FYI, there's a new build failure on 32-bit x86 caused by the new max2165 
> tuner driver:
> 
> drivers/built-in.o: In function `max2165_set_params':
> max2165.c:(.text+0x486293): undefined reference to `__floatunsidf'
> max2165.c:(.text+0x4862bc): undefined reference to `__floatunsidf'
> max2165.c:(.text+0x4862c5): undefined reference to `__adddf3'
> max2165.c:(.text+0x4862cf): undefined reference to `__fixunsdfsi'
> 
> 	Ingo


A patch is already submitted to v4l mailing list:
http://patchwork.kernel.org/patch/64538/

David
