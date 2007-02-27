Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbXB0IfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbXB0IfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbXB0IfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:35:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:6357 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbXB0IfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Oa5LQMwWw71Tj0bCra2MAnl2+4GO5CFoZV7aYoeSlbSdl2/Lz2igenDZLX+yoTIE6GQPmiUwdV8nKGeAeACqbVeOs/9MJQoHN5Dx3FsK/kon8OpyI8nAmOWrz4No3xIJe/R0WnmsnfWvV0PcNyhD2HLLqjqlOOB3ABtTaCAc7Y8=
Message-ID: <45E3ECF1.4040906@googlemail.com>
Date: Tue, 27 Feb 2007 09:33:53 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David P. Reed" <dpreed@reed.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       jgarzik@pobox.com, netdev@vger.kernel.org,
       Albert Hopkins <kernel@marduk.letterboxes.org>,
       Bob Tracy <rct@gherkin.frus.com>, Mark Brown <broonie@sirena.org.uk>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>	 <20070226220521.GB29575@stusta.de> <1172564491.3709.5.camel@chaos>
In-Reply-To: <1172564491.3709.5.camel@chaos>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner napisa³(a):
> Adrian,
> 
> On Mon, 2007-02-26 at 23:05 +0100, Adrian Bunk wrote:
>> Subject    : kernel BUG at kernel/time/tick-sched.c:168  (CONFIG_NO_HZ)
>> References : http://lkml.org/lkml/2007/2/16/346
>> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
>> Handled-By : Thomas Gleixner <tglx@linutronix.de>
>> Status     : problem is being debugged
> 
> The BUG_ON() was replaced by a warning printk(). The BUG_ON() exposed a
> problem with the SMT scheduler. See below.
> 
>> Subject    : BUG: soft lockup detected on CPU#0
>>              NOHZ: local_softirq_pending 20  (SMT scheduler)
>> References : http://lkml.org/lkml/2007/2/20/257
>> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
>> Handled-By : Thomas Gleixner <tglx@linutronix.de>
>>              Ingo Molnar <mingo@elte.hu>
>> Status     : problem is being debugged
> 
> Patch available, not confirmed yet.
> 

I can confirm that the bug is fixed (over 20 hours of testing should be enough).

Huge thanks!

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
