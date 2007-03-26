Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbXCZMZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbXCZMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbXCZMZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:25:29 -0400
Received: from gherkin.frus.com ([192.158.254.49]:46320 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbXCZMZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:25:28 -0400
Subject: Re: Linux 2.6.21-rc5
In-Reply-To: <1174899300.4182.8.camel@chaos> "from Thomas Gleixner at Mar 26,
 2007 10:55:00 am"
To: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 26 Mar 2007 07:25:26 -0500 (CDT)
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       johnstul@us.ibm.com
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070326122526.BD45DDBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> This fix from John Stultz is still missing:
> 
> http://lkml.org/lkml/2007/3/22/287
> 
> It's in Andrews queue already and waits to be sent to you.

In summary, that fix is a workaround to allow the acpi_pm clocksource
to be selected instead of the pit clocksource, thereby allowing my
Dell laptop with the PIIX4 bug to boot.  Other apic, clocksource, etc.
patches that were included in -rc5 fixed the problem that caused the
boot process to hang when the pit clocksource was selected, as I
suspected would be the case :-).

Per John's message in the above URL, while the fix is no longer needed
for allowing the laptop to boot, it's probably still "a good thing" to
allow a better clocksource to be selected.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
