Return-Path: <linux-kernel-owner+w=401wt.eu-S1752290AbZL2S72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbZL2S72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZL2S71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:59:27 -0500
Received: from dhael.aehallh.com ([63.254.233.42]:53106 "EHLO
	dhael.aehallh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZL2S71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:59:27 -0500
Date: Tue, 29 Dec 2009 13:59:26 -0500
From: "Zephaniah E. Hull" <warp-spam_kernel@aehallh.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       warp-spam_kernel@aehallh.com
Subject: Re: [Bug #14862] intel-agp breaks X, regression from 2.6.31
Message-ID: <20091229185926.GP19249@aehallh.com>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
 <srmJ8vMxKPH.A.ujC.cwhOLB@chimera>
 <20091229184220.GO19249@aehallh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091229184220.GO19249@aehallh.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 01:42:20PM -0500, Zephaniah E. Hull wrote:
> On Tue, Dec 29, 2009 at 04:28:51PM +0100, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14862
> > Subject		: intel-agp breaks X, regression from 2.6.31
> > Submitter	: Zephaniah E. Hull. <warp-spam_kernel@aehallh.com>
> > Date		: 2009-12-22 22:59 (8 days old)
> 
> I plan on testing 2.6.32.2 later today in hopes that some of the IOMMU
> changes will have done something in regards to this.

#14627 and this bug are duplicates.

Bugs #14900, and #14728 look very suspiciously like they might be the
same thing as well.

I would be interested to see if commenting out:
'#define USE_PCI_DMA_API 1' in drivers/char/agp/intel-agp.c fixes the
problem for those bugs as well.

I suspect that some better run time checking is called for here.

Zephaniah E. Hull.
(And please keep me on the CC list, I am not subscribed to LKML or KTL.)
