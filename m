Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab0BETKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 14:10:32 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:37523 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab0BETKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 14:10:31 -0500
Date: Fri, 5 Feb 2010 14:09:16 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Wilson <chris@chris-wilson.co.uk>, tomas m <tmezzadra@gmail.com>
Subject: Re: [Bug #15004] i915: *ERROR* Execbuf while wedged
Message-ID: <20100205190916.GD2858@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	tomas m <tmezzadra@gmail.com>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
 <de962C6zBxL.A.bvE.cFiZLB@chimera>
 <20100205110100.57852c31@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205110100.57852c31@jbarnes-piketon>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B6C6D0E.0032:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 11:01:00AM -0800, Jesse Barnes wrote:
> On Mon,  1 Feb 2010 01:43:19 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still
> > should be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15004
> > Subject		: i915: *ERROR* Execbuf while wedged
> > Submitter	: tomas m <tmezzadra@gmail.com>
> > Date		: 2010-01-07 18:53 (25 days old)
> 
> Can you bisect this to a particular kernel commit?  The particular
> error message means the kernel detected a GPU hang.  That's usually
> a userspace bug, but the kernel should recover from it.

I see these about once a week, which would be a very difficult bisect.
The kernel does recover when I reboot, but beyond that the messages loop
forever.

I haven't yet seen it on 2.6.33-rc, but I'm still struggling with
suspend/resume failures and haven't really had a one week up time yet.

-chris

