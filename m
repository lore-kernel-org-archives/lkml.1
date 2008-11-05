Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYKEOFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYKEOFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 09:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYKEOFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 09:05:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYKEOFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 09:05:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: sys_sched_yield keeps locked irq before call of schedule()
Date: Wed, 5 Nov 2008 15:05:15 +0100
User-Agent: KMail/1.9.9
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
References: <c4e36d110811050457m36346fe1m63ffbb143f684637@mail.gmail.com> <20081105130113.GB29548@elte.hu> <c4e36d110811050509t51719671saa7eb337fca39656@mail.gmail.com>
In-Reply-To: <c4e36d110811050509t51719671saa7eb337fca39656@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811051505.16145.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/ILyh5yuJftSBAg05Uob7Qc49UHiSWwPQ8nOr
 F+NXShgAXp6wrNdNuKEhRNx5UUjDMZzPa+JZXswaHIA05CwWi8
 nEXZCDVO2oideFjxS2y9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 November 2008, Zdenek Kabelac wrote:
> > is this some special warning you added? The stock kernel certainly
> > does not emit this warning.
> 
> Yes - it's my personal debug checker that tries to watch wether irq &
> irqsafe are running in pair.
> So it shows a warning if there is a call of spin_lock_irq and irq is
> already dissabled.

I've done such a checker before as well, but back then it showed
far too many false positives. If you have a working version, can you
post your patch here? I think that would be very useful in the kernel.

	Arnd <><
