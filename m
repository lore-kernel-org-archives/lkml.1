Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZBPPbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZBPPbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZBPPbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:31:10 -0500
Received: from homer.mvista.com ([63.81.120.155]:62720 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750825AbZBPPbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:31:09 -0500
Message-ID: <499986D0.3000205@ru.mvista.com>
Date: Mon, 16 Feb 2009 18:31:28 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Cc: Justin Madru <jdm64@gawab.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12263] Sata soft reset filling log
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <200902152221.43834.rjw@sisk.pl> <20090215223045.GC29300@elte.hu> <200902160012.57584.rjw@sisk.pl> <499983DF.5050503@ru.mvista.com> <49998480.3090408@ru.mvista.com>
In-Reply-To: <49998480.3090408@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>>>>> This message has been generated automatically as a part of a report
>>>>>>> of regressions introduced between 2.6.27 and 2.6.28.

>>>>>>> The following bug entry is on the current list of known regressions
>>>>>>> introduced between 2.6.27 and 2.6.28.  Please verify if it still 
>>>>>>> should
>>>>>>> be listed and let me know (either way).

>>>>>>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=12263
>>>>>>> Subject        : Sata soft reset filling log
>>>>>>> Submitter    : Justin Madru <bevicm@dslextreme.com>
>>>>>>> Date        : 2008-12-13 2:07 (64 days old)
>>>>>>> References    : 
>>>>>>> http://marc.info/?l=linux-kernel&m=122913412608533&w=4

>>>>>> I'm still seeing this on .29-rc5, and I think that my bug #12263 
>>>>>> is a duplicate of bug #12609,
>>>>>> or more correctly it's a duplicate of mine because I reported first.

>>>>>> It seems like the bug has been fixed in tip/master for some time now.
>>>>>> Below is the diff of origin and tip from when I tested.

>>>>> Ingo, do you know whinch patch in -tip fixes this regression?

>>>> This one, done on Jan 10, more than a month ago:

>>>>  f1d26da: Revert "libata: Add 32bit PIO support"

>>>> When a commit causes trouble in -tip qa i immediately revert it in 
>>>> 95% of the cases, no questions asked. Especially if it's related to 
>>>> persistent storage.

>>> OK, thanks.

>>> We seem to have a working fix patch for this issue in bug #12609.

>>    Wait, if this is indeed post-2.6.27 regression, it couldn't 
>> possibly have been caused by that patch which got merged during 
>> 2.6.29-rc1 timeframe. Something's up with this bug...

>    Also, it's been reported for a hard disk while regression in bug 
> 12609 only hits the ATAPI devices.  I think that bug 12263 needs to be reopened.

    After referring to the SCSI command codes "cdb 0x1e" means ALLOW MEDIUM 
REMOVAL command -- which could hardly be addressed to an usual hard disk. So, 
it looks like we had a case of the confused bug report which has a lot of info 
on the hard disk while errors were most probably happening with a CD/DVD 
drive. :-)

MBR, Sergei
