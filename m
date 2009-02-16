Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZBPTmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZBPTmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZBPTlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:41:55 -0500
Received: from ns2.mvista.com ([63.81.120.155]:1112 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750732AbZBPTly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:41:54 -0500
Message-ID: <4999C195.5050905@ru.mvista.com>
Date: Mon, 16 Feb 2009 22:42:13 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Justin Madru <jdm64@gawab.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12263] Sata soft reset filling log
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <200902152221.43834.rjw@sisk.pl> <20090215223045.GC29300@elte.hu> <200902160012.57584.rjw@sisk.pl> <499983DF.5050503@ru.mvista.com> <49998480.3090408@ru.mvista.com> <499986D0.3000205@ru.mvista.com> <4999BD1A.1060101@gawab.com>
In-Reply-To: <4999BD1A.1060101@gawab.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Justin Madru wrote:

>> After referring to the SCSI command codes "cdb 0x1e" means ALLOW 
>> MEDIUM REMOVAL command -- which
>> could hardly be addressed to an usual hard disk. So, it looks like we 
>> had a case of the confused bug report which
>> has a lot of info on the hard disk while errors were most probably 
>> happening with a CD/DVD drive.

> Yes, I originally thought it was my hard disk because the kernel logs 
> showed ata2.

> But, Tejun Heo figured out it was my DVD drive (ATAPI) that was on the 
> ata2 link.

> (see http://marc.info/?l=linux-kernel&m=122993014109646&w=2)

> I tried to bisect it, but around .28-rc1 I began to get numerous compile 
> errors, so couldn't continue.

> I also tried patches that Tejun sent me, but non of them worked, it just 
> slightly change the error message.

> So, yes this is a regression that was introduced in the .28 merge 
> window, and I still think that bug #12609 is a duplicate of my bug.

    If 12609 is truly a post-2.6.28 regression and 12263 is post-2.6.27 
regresssion, this just cannot be.

> I don't see this bug on tip/master and this is the diff of origin and 
> tip at the time I tested.

> $ git diff origin/master..tip/master drivers/ata/

    What tree is that?

WBR, Sergei
