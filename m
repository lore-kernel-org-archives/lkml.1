Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZASQ7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZASQ7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbZASQ7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:59:22 -0500
Received: from relay1.sgi.com ([192.48.179.29]:60696 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754718AbZASQ7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:59:20 -0500
Message-ID: <4974B160.80808@sgi.com>
Date: Mon, 19 Jan 2009 08:59:12 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Pavel Machek <pavel@suse.cz>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.29-rc1: [SOLVED] thinkpad problems during resume
References: <20090113081316.GA2292@elf.ucw.cz> <200901171648.34155.borntraeger@de.ibm.com> <49723602.4090202@sgi.com> <200901180042.40284.borntraeger@de.ibm.com>
In-Reply-To: <200901180042.40284.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
>> Could you try one more experiment?  With your working system, please cherry
>> pick these commits and try it again?
>>
>> 68564a4... work_on_cpu: don't try to get_online_cpus() in work_on_cpu.
>> e1d9ec6... work_on_cpu: Use our own workqueue.
>> 6eb714c... cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and
>> drv_write
>>
>> From
>> git://git.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for
>> -ingo.git
>>
>> If that works, then try and un-revert e39ad415ac and see if it's fixed as
>> well?
> 
> Yes that works.
> 
> 29-rc2 + your 3 patches cherry-picked + revert of 
> a0d4922da2e4ccb0973095d8d29f36f6b1b5f703( usb problem) can suspend/resume. 
> If you like, you can add an
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> to your three patches.
> 
> 
Thanks Christian!

