Return-Path: <linux-kernel-owner+w=401wt.eu-S1031567AbXD1Q4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031567AbXD1Q4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031566AbXD1Q4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:56:51 -0400
Received: from www.osadl.org ([213.239.205.134]:47600 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031564AbXD1Q4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:56:50 -0400
Subject: Re: 2.6.21 known regressions (v2) (for -stable team)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>
In-Reply-To: <463375E5.5040108@googlemail.com>
References: <463375E5.5040108@googlemail.com>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 18:58:53 +0200
Message-Id: <1177779533.7646.264.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 18:27 +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of known regressions reported after 2.6.21 release.

Michal, thanks for stepping up !

> Subject    : 2.6.21 - BUG: at arch/i386/kernel/smp.c:177 send_IPI_mask_bitmask()
> References : http://lkml.org/lkml/2007/4/27/621
> Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
> Status     : unknown

Len,

clockevents_notify() is called with the power verify information for an
offline CPU. I can handle this in the clockevents code, but I think acpi
is the correct place.

Thanks,

	tglx



