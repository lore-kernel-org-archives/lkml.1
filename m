Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYIDNhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYIDNhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYIDNho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:37:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYIDNhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 09:37:43 -0400
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
From: Peter Zijlstra <peterz@infradead.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, arozansk@redhat.com, dzickus@redhat.com,
       Thomas.Mingarelli@hp.com, ak@linux.intel.com, mingo@elte.hu
In-Reply-To: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com>
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 15:37:43 +0200
Message-Id: <1220535463.8609.223.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 09:07 -0400, Prarit Bhargava wrote:
> Andi and Ingo,
> 
> This patch is an RFC for the following changes.  If I get a positive review,
> changes to the HP Watchdog timer (currently in the kernel) will also be
> submitted along with this patch.
> 
> Thanks,
> 
> P.
> 
> The drivers/watchdog/hpwdt.c driver requires that all NMIs are processed
> by the driver.  Currently the driver does not do this.  The first
> step is to implement code to allow the default NMI handler to be replaced
> by a custom NMI handler.

Why is the DIE_NMIWATCHDOG notifier not sufficient for this driver?

