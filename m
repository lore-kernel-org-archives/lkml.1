Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbZFKPMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbZFKPMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZFKPL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:11:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbZFKPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:11:56 -0400
Subject: Re: NOHZ: local_softirq_pending 10
From: Peter Zijlstra <peterz@infradead.org>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4A311D2A.808@xs4all.nl>
References: <4A311D2A.808@xs4all.nl>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 17:12:00 +0200
Message-Id: <1244733120.6691.433.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 17:05 +0200, Udo van den Heuvel wrote:
> Hello,
> 
> I found a few of these in my 2.6.29.4-rt16 logs:
> 
> NOHZ: local_softirq_pending 10
> 
> Are they rt-related?
> (I saw them in older kernels without -rt as well)
> How serious? How to fix?

Not really serious, but curious, that appears to be BLOCK_SOFTIRQ, and
the only one I suspected to trigger this would be HRTIMER_SOFTIRQ.

