Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbXBFPQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbXBFPQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 10:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXBFPQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 10:16:19 -0500
Received: from rtr.ca ([64.26.128.89]:3639 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbXBFPQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 10:16:19 -0500
Message-ID: <45C89BC1.9010703@rtr.ca>
Date: Tue, 06 Feb 2007 10:16:17 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> <1170710272.29759.894.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org> <1170711587.29759.909.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> <1170712393.29759.925.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org> <20070205143110.fca62b57.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm with Linus 100% here.

It's really irritating to upgrade to a newer kernel,
using the same old .config file, and then discover that
my MythTV box no longer auto-boots to record programs.

The reason being, that /proc/acpi/alarm no longer exists,
and the kernel option to configure it has mysteriously
disappeared from the menus.

After an hour of hand examining and grep'ing Kconfig files,
I eventually find the secret little totally-unrelated option
that has to be selected to make the ACPI alarm option visible
again.

Doh!

That interface is driven entirely backwards.
The funtionality option should always be visible,
and should "select" (or hey, invent a better mechanism,
I'm not fussy), the underlying crap required to let me use it.

Cheers
