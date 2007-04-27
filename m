Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbXD0VNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbXD0VNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbXD0VNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:13:24 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:34647 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757306AbXD0VNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:13:23 -0400
Date: Fri, 27 Apr 2007 23:04:58 +0200
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang - bisection result
Message-ID: <20070427210458.GA4302@aitel.hist.no>
References: <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz> <20070412202519.GB14705@aitel.hist.no> <Pine.LNX.4.64.0704130107170.12991@twin.jikos.cz> <462F2558.5010909@aitel.hist.no> <Pine.LNX.4.64.0704251324540.20657@twin.jikos.cz> <46312787.1020702@aitel.hist.no> <Pine.LNX.4.64.0704270038150.20657@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704270038150.20657@twin.jikos.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 12:39:19AM +0200, Jiri Kosina wrote:
> On Fri, 27 Apr 2007, Helge Hafting wrote:
> 
> > 2.6.21-rc6 boots up fine.  Both rc6 and rc7 has a different problem - 
> > the machine tends to hang after some minutes work in X.  That hang is 
> > unusual in that moving the mouse still move the X cursor, but everything 
> > else stops and sysrq fails me. But that is another story.
> [...]
> > The (first) "hanging" patch in 2.6.21-rc6-mm1 is: git-acpi.patch
> 
> Hi Helge,
> 
> thanks for the effort. If you take stock rc6-mm1 and revert just 
> git-acpi.patch, doesn the machine behave correctly?

Just compiled & booted such a kernel - it came up fine!
So it looks like USB is fine then, and the problem is in
that ACPI patch.

Helge Hafting
