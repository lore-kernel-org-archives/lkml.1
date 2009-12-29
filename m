Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZL2WOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZL2WOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZL2WOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:14:18 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:42463 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZL2WOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:14:18 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
       "Len Brown" <lenb@kernel.org>,
       Malte =?iso-8859-1?Q?Schr=F6der?= <maltesch@gmx.de>
Subject: Re: [Bug #14889] System wakeup by time not working anymore
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
	<srmJ8vMxKPH.A.BaC.ZwhOLB@chimera>
	<87k4w5u1fr.fsf@devron.myhome.or.jp> <200912292235.50104.rjw@sisk.pl>
Date: Wed, 30 Dec 2009 07:14:13 +0900
In-Reply-To: <200912292235.50104.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue, 29 Dec 2009 22:35:50 +0100")
Message-ID: <87zl51sa16.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Tuesday 29 December 2009, OGAWA Hirofumi wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > This message has been generated automatically as a part of a report
>> > of regressions introduced between 2.6.31 and 2.6.32.
>> >
>> > The following bug entry is on the current list of known regressions
>> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
>> > be listed and let me know (either way).
>> >
>> >
>> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14889
>> > Subject		: System wakeup by time not working anymore
>> > Submitter	: Malte Schröder <maltesch@gmx.de>
>> > Date		: 2009-12-03 18:06 (27 days old)
>> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=abd6633c67925f90775bb74755f9c547e30f1f20
>> > References	: http://marc.info/?l=linux-kernel&m=125986362631900&w=4
>> 
>> Specified commit would break the pnp driver which is using
>> driver->shutdown.
>> 
>> Could you test this (untested) patch?
>
> Could you please also attach the patch to the Bugzilla entry?

Ok, I've attached the same patch to bugzilla.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
