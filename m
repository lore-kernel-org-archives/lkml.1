Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXCFA42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXCFA42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXCFA41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:56:27 -0500
Received: from www.osadl.org ([213.239.205.134]:58172 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752697AbXCFA41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:56:27 -0500
Subject: Re: [5/6] 2.6.21-rc2: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Soeren Sonnenburg <kernel@nn7.de>, Len Brown <lenb@kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015040.GJ3441@stusta.de>
	 <1173138193.24738.236.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 02:02:28 +0100
Message-Id: <1173142948.24738.257.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 16:38 -0800, Linus Torvalds wrote:
> > I'm not done with my bisection, but e9e2cdb4 is among the 28 commits left, 
> > so I'm pretty sure I'm hitting the same bug. I'll do a few more bootups to 
> > be 100% sure.
> 
> Ok, it's in the last six candidates, so yeah, I'm pretty sure. I'll do a 
> final compile/boot cycle to verify, but if you don't hear from me, you can 
> pretty much assume that was it.
> 
> Thomas, Ingo, I'd _really_ like to get -rc3 out there, but I'd like to cut 
> down the regression list a bit, and a number of them were about resume 
> from RAM, and this is probably it. So I'd *really* like to get this one 
> nailed, especially since the causing commit is known. Can you look at it 
> as a high-priority thing, please?

Sure. I fought it all day. Can you please test the patch I sent a couple
of minutes ago ? Would be great to have your feedback tomorrow morning. 

We need to fix that ACPI problem (acpi_processor_start is not called
when CPU#1 is resumed) as well. I look into this tomorrow unless Len
beats me.

	tglx


