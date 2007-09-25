Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbXIYUz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbXIYUz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbXIYUzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:55:20 -0400
Received: from www.osadl.org ([213.239.205.134]:52568 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753219AbXIYUzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:55:19 -0400
Subject: Re: [PATCH] x86-64: Disable local APIC timer use on AMD systems
	with C1E
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
In-Reply-To: <200709252255.06039.rjw@sisk.pl>
References: <1190749021.17409.35.camel@chaos>
	 <200709252255.06039.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 22:55:06 +0200
Message-Id: <1190753706.17409.64.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 22:55 +0200, Rafael J. Wysocki wrote:
> I have reworked the patch a bit so that it applies on top of 2.6.23-rc8-mm1
> and compiles (my version is attached).
> 
> With this patch applied, the kernel boots correctly on the nx6325.

I know. It's basically enforced "noapictimer". 

But this still does not explain why your nasty box booted current
mainline with "apicmaintimer" on the kernel command line.

	tglx


