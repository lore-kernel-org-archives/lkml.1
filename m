Return-Path: <linux-kernel-owner+w=401wt.eu-S1422787AbXCGRqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422787AbXCGRqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422867AbXCGRq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:46:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:24367 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422823AbXCGRqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:46:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eTSvpJNUx52mehWSZG/t2UdOB1lFeCbA8O7OsnTvnsQvlok7KY4/FokTUhzW8NCoenj094kglYphwIPILV2oWbJ0FFVpTVQrAfuAadl694VhGenbzp+zBJhTll5z0hfWwM6FnpTDz0FLuSAth/K6HgSCkai5pJ6lV4575kYevTg=
Message-ID: <6bffcb0e0703070945v2c27497fg3d2b94363218fd@mail.gmail.com>
Date: Wed, 7 Mar 2007 18:45:59 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CPU hotplug: call check_tsc_sync_source() with irqs off
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070307171230.GA21593@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	 <45EEB66C.9090901@googlemail.com>
	 <Pine.LNX.4.64.0703070827490.5963@woody.linux-foundation.org>
	 <20070307171230.GA21593@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> > [ Ingo and Thomas added to Cc, because I think this is them.. ]
> >
> > Ingo, I think this came in during commit 95492e4646, "x86: rewrite SMP
> > TSC sync code".
>
> yeah.
>
> > > I get this while
> > > echo shutdown > /sys/power/disk; echo disk > /sys/power/state
> > >
> > > BUG: using smp_processor_id() in preemptible [00000001] code: swsusp_shutdown/3359
> > > caller is check_tsc_sync_source+0x1b/0xef
>
> Michal, could you try the patch below?
>

I think that this patch fixes the problem. Thanks!

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
