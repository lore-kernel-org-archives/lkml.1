Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbXFCWa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbXFCWa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 18:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXFCWau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 18:30:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:48602 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbXFCWat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 18:30:49 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: trenn@suse.de
Subject: Re: [PATCH] ACPI Debug - for test, devel and possibly even for production kernels
Date: Sun, 3 Jun 2007 18:30:32 -0400
User-Agent: KMail/1.9.5
Cc: linux-acpi <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi
References: <1180624839.10908.71.camel@queen.suse.de> <200705311249.12762.lenb@kernel.org> <1180705944.10908.184.camel@queen.suse.de>
In-Reply-To: <1180705944.10908.184.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706031830.33115.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

I'm delighted that you feel that the ACPI debug code is worthy
of being enabled by default in SuSE Linux.  While that certainly
wasn't the intent of the code, I'm open to your suggestions should
you find any issues with it where it doesn't suite your needs.

However, I have no plans to enable CONFIG_ACPI_DEBUG upstream by default.
For I don't expect it to increase the quality of bug reports we receive,
or to foster more participation and support in the community for debugging Linux/ACPI.
Indeed, I believe that end-users want fewer ACPI messages, not more.

I believe that there is a small group of people who are simultaneously
capable and willing to debug the Linux Kernel and AML.
These people already run custom built kernels and can enable CONFIG_ACPI_DEBUG
at will.  I don't believe that enabling it by default in a distribution
kernel has measurable utility for the users and customers outside this
(already served) small group.

Re: bugzilla 7122 and 5534
I do not believe that these are valid examples of where enabling
CONFIG_ACPI_DEBUG by default would have resulted in solution sooner.
While it is true that my team has more ready access to Intel hardware,
I became so alarmed at these failures that I purchased an HP nx2125
and an HP nx6325 to figure out what the HP BIOS developers were thinking.

The nx6325 is now working perfectly -- I test kernels on it almost every day.
The nx6125 is for Alexy, but unfortunately, it seems to be mired
in Russian red tape at the moment.

Regarding the % of AML that Linux is currently taking advantage of.
With a few notable exceptions, Linux is actually ahead of Microsoft
in support for the very latest version of the ACPI specification.
This, of course, is a hollow victory, as vendors don't ship features
that can't be handled by Windows.  But the point is that Linux is leading
here, not following, in support of AML.

Regarding platform specific drivers that use AML.
Everybody appreciates the efforts of the guys that are doing
these drivers -- they make our Linux laptops more useful.
But without vendor support, this requires a heroic effort.

The strategy of SuSE as a Linux distributor should not be
to escalate this heroic effort -- but to make it unnecessary.
Ie. If Brand-X wants to be certified on SuSE, then Brand-X
should provide the appropriate platform specific driver for
Linux  - or support the community with documentation so we can
do it methodically and reliably.

BTW, you mentioned WMI..
I've prototyped a Linux WMI driver, and will release it as soon as
it is in a form where people in addition to just me will find it useful --
probably in July. 

Re: timing
I'd love to be able to check stuff in upstream at any point in the release cycle,
but the reality is that Linus has ACPI on a pretty short leash.
He makes the rules, and I do my best to follow them.
After -rc1 closes, the focus is really on fixing regressions,
and patches which are worthy enough that they'd qualify
for the .stable criteria.  So in this case, we are firmly
past 2.6.22 and into 2.6.23.  Like you, I hope that happens
sooner rather than later.

Note that your earlier version of this patch is already in acpi-test.
I'll try out your update as soon as I return from watching the
Boston Red Sox clobber the New York Yankees at Fenway Park tonight.

thanks,
-Len
