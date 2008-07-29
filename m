Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYG2Iit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYG2Iit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbYG2Iik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:38:40 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:29774 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYG2Iij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f3lYqV4x2cW6OHQTh8Zw/mg4wklU2qprfYTkjFdS/xSlP7nVp6vwj8dOf+Hg8MxUyo
         XgHh2m5IA0Ewh07UYLP51jhlVFahmBpuQE04uQmLMc7058Y/AQ7hZpwM+qTriX7ANXqy
         0crkC8ILmLz8diaY1neTEaCBlZUJfDZcO/2Uw=
Message-ID: <a4423d670807290138p4a666337id74fe1fa637932e4@mail.gmail.com>
Date: Tue, 29 Jul 2008 12:38:38 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: sparc64: build failure at sys_sparc32.c
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080729.001256.203097603.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729065914.GA30878@orion>
	 <20080729.001256.203097603.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/29 David Miller <davem@davemloft.net>:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> Date: Tue, 29 Jul 2008 10:59:14 +0400
>
>> I am testing build using randconfig.
>>
>> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_chown16':
>> arch/sparc64/kernel/sys_sparc32.c:63: error: implicit declaration of
>> function 'low2highuid'
>> arch/sparc64/kernel/sys_sparc32.c:63: error: implicit declaration of
>> function 'low2highgid'
>> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_getresuid16':
>> arch/sparc64/kernel/sys_sparc32.c:106: error: implicit declaration of
>> function 'high2lowuid'
>> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_getresgid16':
>> arch/sparc64/kernel/sys_sparc32.c:123: error: implicit declaration of
>> function 'high2lowgid'
>>
>> These functions are defined in linux/highuid.h only if CONFIG_UID16 is enabled.
>
> Thanks, what kernel version is this?

It is current by default - .27-rc1. These files were not touched for a
long time.
But, OK, I will mention the kernel version every time.
