Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbXDZWjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbXDZWjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbXDZWjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:39:36 -0400
Received: from twin.jikos.cz ([213.151.79.26]:46732 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbXDZWjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:39:35 -0400
Date: Fri, 27 Apr 2007 00:39:19 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Helge Hafting <helge.hafting@aitel.hist.no>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang - bisection result
In-Reply-To: <46312787.1020702@aitel.hist.no>
Message-ID: <Pine.LNX.4.64.0704270038150.20657@twin.jikos.cz>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
 <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org>
 <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz>
 <20070412202519.GB14705@aitel.hist.no> <Pine.LNX.4.64.0704130107170.12991@twin.jikos.cz>
 <462F2558.5010909@aitel.hist.no> <Pine.LNX.4.64.0704251324540.20657@twin.jikos.cz>
 <46312787.1020702@aitel.hist.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Helge Hafting wrote:

> 2.6.21-rc6 boots up fine.  Both rc6 and rc7 has a different problem - 
> the machine tends to hang after some minutes work in X.  That hang is 
> unusual in that moving the mouse still move the X cursor, but everything 
> else stops and sysrq fails me. But that is another story.
[...]
> The (first) "hanging" patch in 2.6.21-rc6-mm1 is: git-acpi.patch

Hi Helge,

thanks for the effort. If you take stock rc6-mm1 and revert just 
git-acpi.patch, doesn the machine behave correctly?

-- 
Jiri Kosina
