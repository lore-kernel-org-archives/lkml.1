Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbXIHQwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbXIHQwy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbXIHQwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:52:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbXIHQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:52:45 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: sata & scsi suggestion for make menuconfig
To: Al Boldi <a1426z@gawab.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sat, 08 Sep 2007 18:52:35 +0200
References: <90ZEn-1YU-3@gated-at.bofh.it> <918Rh-7Or-5@gated-at.bofh.it> <919aD-8ua-7@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IU3Xv-0000d9-K0@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+S0aedXDSQiZPZzhY5xXAlUQ/VERr5v599P/l
 NbaHRBtvO5Uq1qLyU28EqdW6y21mHBvX0MwWWuPHpfeZksESED
 DdGUozxeLxsFbKOnvqzgQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi <a1426z@gawab.com> wrote:
> Alan Cox wrote:

>> > I once sent a patch to make libata a submenu of scsi.
>>
>> Which is wrong
>>
>> Nakked-by: Alan Cox <alan@redhat.com>
>>
>> The general comments about moving this stuff around and making it clearer
>> what sd/sr etc are nowdays are good but hiding libata under SCSI will
>> cause even more confusion than it cures
> 
> That's easy to fix:  just change the SCSI heading to include a libata hint.

I think you're fixing the wrong problem.

The real problem is hiding devices attached to some controlers between
one kind of the controllers. This has been correct whern they were bus-
specific, but since they are now shared by three busses, they should get
their own menu called "(S)ATA/USB/SCSI attached devices" - or whatever a
native speaker would suggest.

Besides that, if I imagine being a semi-novice and searching for IDE
support, I would have a hard time finding the IDE menu, and asuming
PATA to be non-experimental one day, I'd have a hard time deciding
which of the drivers to use. Maybe the SATA-drivers should be put
above the old PATA menu, amd maybe both of the titles should include
"(E)IDE"?

BTW: For CONFIG_ATA, you can replace
"(!M32R && !M68K || BROKEN) && (!SUN4 || BROKEN)"
with "(!M32R && !M68K && !SUN4 || BROKEN)"

BTW2: I think that menu needs very much reordering. "Block devices" should
be renamed to "Other block devices", AGP support should belong into graphics
support, and many other things I don't even know need to be pushed around.
Even ordering by name would be better than the current situation! But it
should be done by someone knowing these devices, I could only do a part.
-- 
Top 100 things you don't want the sysadmin to say:
14. Any more trouble from you and your account gets moved to the 750

Friﬂ, Spammer: NxeCk-fw6@5.7eggert.dyndns.org
