Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbXGFMol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbXGFMol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759645AbXGFMof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:44:35 -0400
Received: from web32606.mail.mud.yahoo.com ([68.142.207.233]:43221 "HELO
	web32606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760232AbXGFMoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:44:34 -0400
X-YMail-OSG: 6AxQ.QIVM1l90UpSm1FXu0IWVweRgo70I6UIyuTI.EPxQOdpPFn1QYZcP0I22zMtDOGAqskiskW1ekiSvnt9V3aglw--
X-RocketYMMF: knobi.rm
Date: Fri, 6 Jul 2007 05:44:33 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Reply-To: knobi@knobisoft.de
Subject: Re: Understanding I/O behaviour
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <791963.30234.qm@web32606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Figureau wrote:

>> CFQ gives less (about 10-15%) throughput except for the kernel
>> with the
>> cfs cpu scheduler, where CFQ is on par with the other IO
>> schedulers.
>>
>
>Please have a look to kernel bug #7372:
>http://bugzilla.kernel.org/show_bug.cgi?id=7372
>
>It seems I encountered the almost same issue.
>
>The fix on my side, beside running 2.6.17 (which was working fine
>for me) was to:
>1) have /proc/sys/vm/vfs_cache_pressure=1
>2) have /proc/sys/vm/dirty_ratio=1 and 
> /proc/sys/vm/dirty_background_ratio=1
>3) have /proc/sys/vm/swappiness=2
>4) run Peter Zijlstra: per dirty device throttling patch on the
> top of 2.6.21.5:
>http://www.ussg.iu.edu/hypermail/linux/kernel/0706.1/2776.html

Brice,

 any of them sufficient, or all together nedded? Just to avoid
confusion.

Cheers
Martin


------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
