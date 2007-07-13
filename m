Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbXGMRRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbXGMRRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXGMRR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:17:28 -0400
Received: from h155.mvista.com ([63.81.120.155]:45202 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751282AbXGMRR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:17:27 -0400
Message-ID: <4697B421.6010005@ru.mvista.com>
Date: Fri, 13 Jul 2007 21:19:29 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@elte.hu, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       dwalker@mvista.com
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: revert fix for threaded fasteoi	IRQ
 handlers
References: <200611192243.34850.sshtylyov@ru.mvista.com>	 <200705171719.34968.sshtylyov@ru.mvista.com>	 <46965B28.7000703@ru.mvista.com> <1184259173.12353.227.camel@chaos>
In-Reply-To: <1184259173.12353.227.camel@chaos>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thomas Gleixner wrote:

>>    Now that the -rt patch has been first release in the broken-out version, 
>>let me tell you that the following 3 patches in the series can be just 
>>annihilated:

>>preempt-irqs-ppc-ack-irq-fixups.patch
>>preempt-irqs-ppc-fix-b5.patch
>>preempt-irqs-ppc-fix-more-fasteoi.patch

>>as all that the latter two are doing is undoing the former one.

> Really ? I know for quite a while. 

    Just reminding. :-)

> We kept some of those files to document contributions. Go read back on
> the LKML archives, where we were accused more than once not to keep
> track of these things.

    Yeah, I figured that out. This case is somewhat special though since the 
patch that started this should't even have been there in the firts place.

> They can be folded together and fixed up, one thing after the other
> please.

    OK, no hurry. :-)

> 	tglx

WBR, Sergei
