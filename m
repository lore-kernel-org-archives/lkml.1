Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbXFTSK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbXFTSK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbXFTSKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:10:19 -0400
Received: from homer.mvista.com ([63.81.120.155]:54009 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753906AbXFTSKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:10:17 -0400
Message-ID: <46796DEE.5090206@ru.mvista.com>
Date: Wed, 20 Jun 2007 22:11:58 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Breeds <tony@bakeyournoodle.com>, Daniel Walker <dwalker@mvista.com>,
       Andrew Morton <akpm@osdl.org>, john stultz <johnstul@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] clocksouce implementation for powerpc
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>	 <20070616101637.107940593@inhelltoy.tec.linutronix.de>	 <1182009083.11539.369.camel@imap.mvista.com>	 <20070620065710.GR9768@bakeyournoodle.com>	 <1182351439.18168.79.camel@imap.mvista.com>	 <467961F1.1060909@ru.mvista.com> <1182360681.3316.25.camel@chaos>
In-Reply-To: <1182360681.3316.25.camel@chaos>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thomas Gleixner wrote:

>>>>+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
>>>>+{
>>>>+	timer_recalc_offset(tb_last_jiffy);
>>>>+	timer_check_rtc();
>>>>+}
>>
>>>Hmm .. This doesn't look like it's taking into account that the time has
>>>changed ..
>>
>>    Why? By the time it gets called (form the timer softirq context) 
> 
> 
> It is called from interrupt context at least in mainline. Only the -rt
> patch moves this to the softirq.

    Anyway, by the time it gets called, tb_last_jiffy gets updated.

> 	tglx

WBR, Sergei
