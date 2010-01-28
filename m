Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155Ab0A1L7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0A1L7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155Ab0A1L7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:59:08 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9969 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab0A1L7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:59:05 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Date: Thu, 28 Jan 2010 12:57:47 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: RE: [PATCH/RFC v2 0/3] Human readable platform-specific performance
 event support
In-reply-to: <1264675934.4283.2088.camel@laptop>
To: "'Peter Zijlstra'" <peterz@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       acme@redhat.com, jamie.iles@picochip.com, will.deacon@arm.com,
       jpihet@mvista.com, mingo@elte.hu, Pawel Osciak <p.osciak@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>, kyungmin.park@samsung.com,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <000101caa011$1ba9ee10$52fdca30$%fujak@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AcqgCBU9yYOWieoRSISAIA9yscr8MAACKhCQ
References: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
 <1264675934.4283.2088.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Thursday, January 28, 2010 11:52 AM
> To: Tomasz Fujak
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> acme@redhat.com; jamie.iles@picochip.com; will.deacon@arm.com;
> jpihet@mvista.com; mingo@elte.hu; p.osciak@samsung.com;
> m.szyprowski@samsung.com; kyungmin.park@samsung.com;
> m.nazarewicz@samsung.com
> Subject: Re: [PATCH/RFC v2 0/3] Human readable platform-specific
> performance event support
> 
> On Thu, 2010-01-28 at 10:34 +0100, Tomasz Fujak wrote:
> > Human readable description support for performance events v2. With
> perf support included.
> > Changes from v1:
> >  - applied on top of latest perf_event/ARM (5899/1 - 5903/1)
> >  - moved to debugfs, now based on seq_file
> >  - reads one line at a time, memory overallocation fixed [perf]
> 
> You can keep sending these patches, but I'll keep ignoring them
> eventually adding you to the /dev/null redirect.

Apparently I did not comprehend your attitude towards the events' description being exported from the kernel.
There's been a lengthy discussion which ended in a conclusion that the platform detection is a complicated task.

The solution finally accepted covers just a subset of platforms. I guess the detection scheme may be updated and possibly changed as new cores/implementers come into sight.
That I think provides additional reasoning to keep the event list where it's defined (in the kernel).
The rest of the suggestions (perf implementation, debugfs instead of sysfs) I've included into the posted patches.

Therefore I cannot really understand why you're threatening to ignore my further efforts; especially since the arguments me and my teammate Michal brought I find reasonable.

So finally, if the proposed patches are too intrusive, can you imagine other mechanism in the kernel that would let the userspace unambiguously retrieve a list of supported events?
Maybe an entry in the sysfs that indicates supported event list version (relevant to the implementer, cupid and other black magic that is involved into the platform detection)?

Right now what can be done is to try follow the kernel implementation of the detection scheme in the applications, which I can't say I'm a fan of.


