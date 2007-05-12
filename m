Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbXELDwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbXELDwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 23:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXELDw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 23:52:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:58495 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbXELDw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 23:52:27 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Pavel Machek <pavel@ucw.cz>, Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [PATCH] swsusp: Use platform mode by default
Date: Fri, 11 May 2007 23:50:43 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Coywolf Qi Hunt <coywolf@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Stefan Seyfried <seife@suse.de>
References: <200611011323.14830.rjw@sisk.pl> <alpine.LFD.0.98.0705111550540.3986@woody.linux-foundation.org> <20070511232326.GB28092@elf.ucw.cz>
In-Reply-To: <20070511232326.GB28092@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705112350.43462.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I agree that we should keep the "platform" default,
as it went in 2 releases ago (nearly 6 months) without
any reported failures until this one -- and it fixed
a longstanding issue documented on many machines.

We should debug Qi's failure like any other.
We are actually in better shape on this one than others
because we already know something that works around it.

Qi,
Please open a bug report here:

http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
in the Power-Off category.  There are some other open
poweroff bugs and maybe we'll find a common thread.
Please attach the output from acpidump and
dmesg -s64000.

thanks,
-Len
