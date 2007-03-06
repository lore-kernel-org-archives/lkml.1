Return-Path: <linux-kernel-owner+w=401wt.eu-S1750828AbXCFIDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750828AbXCFIDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXCFIDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:03:23 -0500
Received: from www.osadl.org ([213.239.205.134]:53936 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750828AbXCFIDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:03:22 -0500
Subject: Re: [5/6] 2.6.21-rc2: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Len Brown <lenb@kernel.org>
In-Reply-To: <20070306072542.GA30153@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015040.GJ3441@stusta.de>
	 <1173138193.24738.236.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org>
	 <1173142948.24738.257.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org>
	 <20070306072542.GA30153@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 09:09:25 +0100
Message-Id: <1173168565.24738.273.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 08:25 +0100, Ingo Molnar wrote:
> The programming of periodic tick devices needs to be saved/restored 
> across suspend/resume - otherwise we might end up with a system coming 
> up that relies on getting a PIT (or HPET) interrupt, while those devices 
> default to 'no interrupts' after powerup. (To confuse things it worked 
> to a certain degree on some systems because the lapic gets initialized 
> as a side-effect of SMP bootup.)
> 
> This suspend / resume thing was dropped unintentionally during the 
> last-minute -mm code reshuffling.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


