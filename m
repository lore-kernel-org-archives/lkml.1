Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbYLLCSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbYLLCSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 21:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbYLLCSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 21:18:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757018AbYLLCSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 21:18:14 -0500
Date: Thu, 11 Dec 2008 18:17:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [mmotm-2008-12-11-15-20] __unsafe() not defined.
Message-Id: <20081211181733.7031df32.akpm@linux-foundation.org>
In-Reply-To: <200812120209.mBC29Qx5064845@www262.sakura.ne.jp>
References: <200812120209.mBC29Qx5064845@www262.sakura.ne.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 11:09:26 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> I got this compilation error using gcc (GCC) 3.3.5 (Debian 1:3.3.5-13).
> 
>   drivers/pci/hotplug/ibmphp_core.c: In function `ibmphp_init':
>   drivers/pci/hotplug/ibmphp_core.c:1409: error: implicit declaration of function `__unsafe'
>   make[3]: *** [drivers/pci/hotplug/ibmphp_core.o] Error 1
>   make[2]: *** [drivers/pci/hotplug] Error 2
>   make[1]: *** [drivers/pci] Error 2
>   make: *** [drivers] Error 2
> 
> "grep -Fr __unsafe ." shows only one line.
> 
>   ./drivers/pci/hotplug/ibmphp_core.c:    __unsafe(THIS_MODULE);
> 
> Where is __unsafe defined?
> 

hm, I wonder what that was all about.

I'll drop ibmphp-fix-module-ref-count-underflow.patch, thanks.
