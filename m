Return-Path: <linux-kernel-owner+w=401wt.eu-S1752013AbXCST4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbXCST4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbXCST4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:56:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:41886 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbXCST4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VoYw0hKPCrpW8VKXY7ZXhk+kW28s7bSU5viYXnKXtAf52xbf+QvqQpgAeQYH3K/f1PT2u4BTFmSNepHXB8OZ43YkMQk+RqD14AsZyGLNo+wAIMJFViCnCH3sjhtjzSwIrglF5ovocU1jUav8CHQyWIE6ylHEPoisaofmES1qifI=
Message-ID: <6bffcb0e0703191256r56eca01eufe7368a43967fb5c@mail.gmail.com>
Date: Mon, 19 Mar 2007 20:56:43 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On 18/03/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> The mm snapshot broken-out-2007-03-18-02-44.tar.gz has been uploaded to
>
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-18-02-44.tar.gz
>
> It contains the following patches against 2.6.21-rc4:

I reported this a few days ago.

  BUG: at kernel/lockdep.c:2428 check_flags()
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c013e1b5>] check_flags+0xb7/0x187
 [<c01413ea>] lock_acquire+0x3a/0x93
 [<c033ef57>] _spin_lock+0x35/0x42
 [<c014a957>] refrigerator+0x14/0xb5
 [<c012efe6>] get_signal_to_deliver+0x42/0x709
 [<c0103786>] do_notify_resume+0x94/0x778
 [<c0104339>] work_notifysig+0x13/0x1a
 =======================
irq event stamp: 178563
hardirqs last  enabled at (178563): [<c0104391>] syscall_exit_work+0x11/0x26
hardirqs last disabled at (178562): [<c010427d>] syscall_exit+0x9/0x1a
softirqs last  enabled at (178170): [<c0128e58>] __do_softirq+0xe4/0xea
softirqs last disabled at (178163): [<c0128e97>] do_softirq+0x39/0x55
hardirqs last  enabled at (2825): [<c033f525>] _spin_unlock_irqrestore+0x36/0x69
hardirqs last disabled at (2826): [<c033f1a7>] _spin_lock_irqsave+0x12/0x4e
softirqs last  enabled at (2808): [<c0128e58>] __do_softirq+0xe4/0xea
softirqs last disabled at (2801): [<c0128e97>] do_softirq+0x39/0x55

cpu-hotplug test hangs on this

CPU 1 is now offline
lockdep: not fixing up alternatives.
BUG: at kernel/lockdep.c:2430 check_flags()

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-03-18-02-44/mm-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-03-18-02-44/mm-console3-swsusp-and-cpu-hotplug.log

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
