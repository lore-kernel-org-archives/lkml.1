Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbYHFPqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbYHFPqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030480AbYHFPpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:45:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:47689 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964850AbYHFPpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:45:04 -0400
Date: Wed, 6 Aug 2008 08:44:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: Re: [patch 3/5] [PATCH 3/5] x86: Run Intel ucode-updates via
 workqueue.
Message-ID: <20080806084446.68683aaf@infradead.org>
In-Reply-To: <20080806152319.773811325@amd.com>
References: <20080806152117.198754464@amd.com>
	<20080806152319.773811325@amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 17:21:20 +0200
Peter Oruba <peter.oruba@amd.com> wrote:

[ no description or reason ]

Why is this?

I'm not very happy about this.. it means practically that this stuff
*has* to run late. Probably later than we want to.
(Like.. we may want to redo the microcode during resume.. which is
not a schedulable context)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
