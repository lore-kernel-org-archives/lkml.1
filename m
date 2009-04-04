Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZDDHlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZDDHlD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 03:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbZDDHkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 03:40:51 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:31150 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbZDDHku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 03:40:50 -0400
Date: Sat, 04 Apr 2009 03:40:45 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.29-rc6-git7: Reported regressions from 2.6.28
In-reply-to: <200903072312.30158.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.0904040339470.16220@localhost.localdomain>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
 <1236129688.32297.264.camel@rzhang-dt> <200903072312.30158.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Mar 2009, Rafael J. Wysocki wrote:

> On Wednesday 04 March 2009, Zhang Rui wrote:
> > On Wed, 2009-03-04 at 03:22 +0800, Rafael J. Wysocki wrote:
> > 
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12758
> > > Subject         : ACPI exception with 2.6.29-rc6
> > > Submitter       : Heinz Diehl <htd@fancy-poultry.org>
> > > Date            : 2009-02-23 16:46 (9 days old)
> > > References      : http://marc.info/?l=linux-kernel&m=123540758700861&w=4
> > > 
> > Handled by: Len Brown <len.brown@intel.com>
> > Patch-available:
> > http://bugzilla.kernel.org/attachment.cgi?id=20368&action=view
> > 
> > not sure if this patch is in len's tree or not.
> 
> Thanks, updated.


per the bug report, this shipped in 2.6.29-rc8:

commit 7b46ecd5fcebf381a7bde966db352d8fb1b8e944
Author: Len Brown <len.brown@intel.com>
Date:   Wed Feb 25 18:00:18 2009 -0500

    Revert "ACPI: make some IO ports off-limits to AML"

