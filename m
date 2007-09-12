Return-Path: <linux-kernel-owner+w=401wt.eu-S970997AbXILRT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970997AbXILRT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968879AbXILRTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:19:19 -0400
Received: from www.osadl.org ([213.239.205.134]:46306 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S968511AbXILRTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:19:18 -0400
Subject: Re: [1/4] 2.6.23-rc6: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Markus <lists4me@web.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, linux-alpha@vger.kernel.org,
       Stefan Becker <Stefan.Becker@nokia.com>, Andi Kleen <ak@suse.de>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Jakub Jelinek <jakub@redhat.com>,
       Jeff Dike <jdike@linux.intel.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       "Adrian Bunk \"\"" <bunk@kernel.org>
In-Reply-To: <46E81AC6.3000306@googlemail.com>
References: <46E81AC6.3000306@googlemail.com>
Content-Type: text/plain
Date: Wed, 12 Sep 2007 19:19:15 +0200
Message-Id: <1189617555.4513.3.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 18:58 +0200, Michal Piotrowski wrote: 
> Subject         : x86_64 vdso patch is broken somehow?
> References      : http://lkml.org/lkml/2007/8/29/136
> Last known good : ?
> Submitter       : Chuck Ebbert <cebbert@redhat.com>
> Caused-By       : Andi Kleen <ak@suse.de>
>                   commit 2aae950b21e4bc789d1fc6668faf67e8748300b7
> Handled-By      : ?
> Status          : unknown

Patch available:
http://lkml.org/lkml/2007/9/11/161

> Subject         : cpu hotplug support broken in 2.6.23-rc3/highres timers break cpu hotplug in 2.6.23-rc5
> References      : http://lkml.org/lkml/2007/8/27/58
>                   http://lkml.org/lkml/2007/9/3/65
> Last known good : ?
> Submitter       : Pavel Machek <pavel@ucw.cz>
> Caused-By       : ?
> Handled-By      : ?
> Status          : problem is being debugged

This might be the same problem as the jinxed VAIO suspend/resume thingy,
which is a regression as well.

Please assign the Handled-By to me.

Thanks,

	tglx



