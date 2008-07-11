Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYGKMuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYGKMuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYGKMt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:49:56 -0400
Received: from spirit.analogic.com ([204.178.40.4]:4438 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYGKMtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:49:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 11 Jul 2008 12:47:10.0351 (UTC) FILETIME=[3C00E9F0:01C8E354]
Content-class: urn:content-classes:message
Subject: Re: [PATCH 17/18] [GFS2] Remove support for unused and pointlessflag
Date: Fri, 11 Jul 2008 08:47:10 -0400
Message-ID: <Pine.LNX.4.61.0807110845430.18299@chaos.analogic.com>
In-Reply-To: <1215777139.4011.188.camel@quoit>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 17/18] [GFS2] Remove support for unused and pointlessflag
Thread-Index: AcjjVDwIOb0OgcaHTGm0JgD0HnQXnA==
References: <121577107950-git-send-email-swhiteho@redhat.com> <1215771091790-git-send-email-swhiteho@redhat.com> <12157710931623-git-send-email-swhiteho@redhat.com> <12157710954145-git-send-email-swhiteho@redhat.com> <12157710973601-git-send-email-swhiteho@redhat.com> <12157710983282-git-send-email-swhiteho@redhat.com> <12157711013356-git-send-email-swhiteho@redhat.com> <12157711023743-git-send-email-swhiteho@redhat.com> <12157711041157-git-send-email-swhiteho@redhat.com> <1215771106247-git-send-email-swhiteho@redhat.com> <12157711073280-git-send-email-swhiteho@redhat.com> <12157711093284-git-send-email-swhiteho@redhat.com> <12157711133727-git-send-email-swhiteho@redhat.com> <12157711153366-git-send-email-swhiteho@redhat.com> <12157711171692-git-send-email-swhiteho@redhat.com> <1215771119431-git-send-email-swhiteho@redhat.com> <Pine.LNX.4.61.0807110714110.18083@chaos.analog! ic.com> <1215777139.4011.188.camel@quoit>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Steven Whitehouse" <swhiteho@redhat.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1027-16024.007
X-TM-AS-Result: No--19.755000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 11 Jul 2008, Steven Whitehouse wrote:

> Hi,
>
> On Fri, 2008-07-11 at 07:19 -0400, linux-os (Dick Johnson) wrote:
>> On Fri, 11 Jul 2008 swhiteho@redhat.com wrote:
>>
>>> From: Steven Whitehouse <swhiteho@redhat.com>
>>>
>>> The ability to mark files for direct i/o access when opened
>>> normally is both unused and pointless, so this patch removes
>>> support for that feature.
>> [Snipped...]
>>
>> So linux is no longer going to support commercial databases?
[Snipped...]

>>
> No, thats not what it means...., but perhaps I could have explained it
> better. You can still use O_DIRECT flags in open syscalls in exactly the
> same way as before. What this patch removes is the (never used, and IMHO
> pointless) feature of being able to set a flag on the inode (via
> chattr/setattr) to force open's to set O_DIRECT in every case, even when
> the application didn't ask for it. The reason that its pointless is that
> applications which don't otherwise support O_DIRECT are very unlikely to
> supply suitably aligned buffers and I/O requests, so that overriding the
> O_DIRECT flag for such applications will most likely result in an I/O
> error.
>
> GFS2 will still support O_DIRECT just the same as it has always done,
> and this doesn't affect any other filesystem's support for that feature
> either,
>
> Steve.

Thanks for the clarification!

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
