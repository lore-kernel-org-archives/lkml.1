Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZLPDli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZLPDli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZLPDlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:41:36 -0500
Received: from vms173015pub.verizon.net ([206.46.173.15]:45989 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZLPDlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:41:35 -0500
Date: Tue, 15 Dec 2009 22:41:19 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Lin Ming <ming.m.lin@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] 9a884ab64a4d092b4c3bf24fd9a30f7fbd4591e7 causes boot
 hang
In-reply-to: <1260925040.3834.69.camel@minggr.sh.intel.com>
Message-id: <alpine.LFD.2.00.0912152240320.6885@localhost.localdomain>
References: <20091215181538.GA28707@srcf.ucam.org>
 <1260925040.3834.69.camel@minggr.sh.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew,

Alternatively, you can pick up the latest ACPICA code from
the acpica or release branches of the acpi tree.

Please let me know as soon as you can check if it helps.

thanks,
Len Brown, Intel Open Source Technology Center

On Wed, 16 Dec 2009, Lin Ming wrote:

> On Wed, 2009-12-16 at 02:15 +0800, Matthew Garrett wrote:
> > Commit 9a884ab64a4d092b4c3bf24fd9a30f7fbd4591e7 (ACPICA: Add additional 
> > module-level code support) results in one of my test machines hanging at 
> > boot. The last line output is:
> > 
> > bio: create slab <bio-0> at 0
> > 
> > which would normally be followed by
> > 
> > ACPI: EC: Look up EC in DSDT
> > 
> > but instead the machine hangs without printing this line. Reverting the 
> > commit results in the machine booting. acpidump output attached.
> > 
> 
> Hi, Matthew
> 
> Could you try the attached ACPICA latest release (20091214) patch
> series? There are module level code and _REG method fixes included in
> it.
> 
> Checkout Linus' tree.
> git am acpica-v20091214.patch
> 
> Thanks,
> Lin Ming
> 
> 
