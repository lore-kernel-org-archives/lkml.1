Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbXENHwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbXENHwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 03:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXENHwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 03:52:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXENHwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 03:52:00 -0400
Date: Mon, 14 May 2007 09:50:45 +0200
From: Stefan Seyfried <seife@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Coywolf Qi Hunt <coywolf@gmail.com>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Starikovskiy <alexey_y_starikovskiy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] swsusp: Use platform mode by default
Message-ID: <20070514075045.GA10238@suse.de>
References: <200611011323.14830.rjw@sisk.pl> <200705111121.51704.rjw@sisk.pl> <alpine.LFD.0.98.0705110912290.3986@woody.linux-foundation.org> <200705112208.53971.rjw@sisk.pl> <alpine.LFD.0.98.0705111550540.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.98.0705111550540.3986@woody.linux-foundation.org>
X-Operating-System: openSUSE 10.3 (i586) Alpha4, Kernel 2.6.21-3-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 03:51:38PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 11 May 2007, Rafael J. Wysocki wrote:
> > 
> > Just to clarify, the change in question isn't new.  It was introduced by the
> > commit 9185cfa92507d07ac787bc73d06c42222eec7239 before 2.6.20, at Seife's
> > request and with Pavel's acceptance.
> 
> Ok, if it's that old, we migt as leave it in. Clearly there weren't many 
> regressions, and this isn't a case of other monsters lurking behind a lack 
> of testers.

I pushed for this since on ACPI machines, "platform" is the right thing to do,
and i still think it will only break on machines that have a broken ACPI BIOS.
(Are there machines with broken ACPI BIOS around? ;-)

Your additional "fall back to shutdown if !(ops)"-fix looks very sane,
however, and is definitely a good idea.
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
