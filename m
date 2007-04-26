Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbXDZXOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbXDZXOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbXDZXOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:14:06 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186AbXDZXOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:14:03 -0400
Date: Thu, 26 Apr 2007 16:13:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang - bisection result
Message-Id: <20070426161342.4e4dbfdf.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704270038150.20657@twin.jikos.cz>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
	<20070411194227.GA31286@aitel.hist.no>
	<20070411134346.d10765da.akpm@linux-foundation.org>
	<20070411230700.GA4023@aitel.hist.no>
	<Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz>
	<20070412202519.GB14705@aitel.hist.no>
	<Pine.LNX.4.64.0704130107170.12991@twin.jikos.cz>
	<462F2558.5010909@aitel.hist.no>
	<Pine.LNX.4.64.0704251324540.20657@twin.jikos.cz>
	<46312787.1020702@aitel.hist.no>
	<Pine.LNX.4.64.0704270038150.20657@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 00:39:19 +0200 (CEST) Jiri Kosina <jikos@jikos.cz> wrote:

> On Fri, 27 Apr 2007, Helge Hafting wrote:
> 
> > 2.6.21-rc6 boots up fine.  Both rc6 and rc7 has a different problem - 
> > the machine tends to hang after some minutes work in X.  That hang is 
> > unusual in that moving the mouse still move the X cursor, but everything 
> > else stops and sysrq fails me. But that is another story.
> [...]
> > The (first) "hanging" patch in 2.6.21-rc6-mm1 is: git-acpi.patch

linux-acpi: we have a problem.

> Hi Helge,
> 
> thanks for the effort. If you take stock rc6-mm1 and revert just 
> git-acpi.patch, doesn the machine behave correctly?
> 

It would be easier and would produce a clearer result to test just

	2.6.21-rc7
+	2.6.21-rc7-mm2's origin.patch
+	2.6.21-rc7-mm2's acpi.patch

from
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/
