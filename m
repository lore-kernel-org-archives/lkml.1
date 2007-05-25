Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbXEYQ5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbXEYQ5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbXEYQ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:57:30 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbXEYQ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:57:29 -0400
Date: Fri, 25 May 2007 09:56:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Uwe Bugla <uwe.bugla@gmx.de>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Message-Id: <20070525095618.1cd86672.akpm@linux-foundation.org>
In-Reply-To: <200705251652.19911.mb@bu3sch.de>
References: <20070524195616.234280@gmx.net>
	<200705251512.09878.mb@bu3sch.de>
	<200705251559.49807.uwe.bugla@gmx.de>
	<200705251652.19911.mb@bu3sch.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 16:52:19 +0200 Michael Buesch <mb@bu3sch.de> wrote:

> I bet your bug is _not_ caused by ssb, but by some other breakage
> in another subsystem. Maybe ACPI or APIC is broken? Try to boot
> the machine without ACPI and/or APIC.

It wouldn't be the first time.

Uwe, please generate the `dmesg -s 1000000' output for 2.6.22-rc2 and for
2.6.22-rc2-mm1, feed them through `diff -u' and see if you can spot any
interesting-looking differences in the PCI/ACPI/IRQ area.  Send both the
files to me and I'll stick them on a server and then I'll see if we can
hunt down the perpetrator.

Thanks.
