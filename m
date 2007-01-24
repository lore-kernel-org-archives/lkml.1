Return-Path: <linux-kernel-owner+w=401wt.eu-S1751188AbXAXLNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbXAXLNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbXAXLNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:13:42 -0500
Received: from www.osadl.org ([213.239.205.134]:48356 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751188AbXAXLNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:13:41 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <1169634220.19471.197.camel@imap.mvista.com>
References: <20070123211159.178138000@localhost.localdomain>
	 <1169604991.19471.95.camel@imap.mvista.com>
	 <20070124070701.GA17654@elte.hu>
	 <1169631016.19471.175.camel@imap.mvista.com>
	 <20070124095157.GA21346@elte.hu>
	 <1169634220.19471.197.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 12:13:57 +0100
Message-Id: <1169637237.21181.164.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 02:23 -0800, Daniel Walker wrote:
> > the 10th major iteration to his codebase. If you have cleanups to his 
> > code then please work with Thomas to get your changes into his tree.
> 
> My code is for clocksouces/timekeeping which has been unrelated to HRT
> up until recently. In my original email I suggested that the two tree's
> be merged ,or placed on top of each other, which I still think is a good
> idea.

This would require, that your patches are solving a real problem. The
last time I looked at them was before they were dropped from -mm. I
disagreed with your intent of sched clock changes back then and I still
do.

OTOH, I needed a clean solution for the TSC verification to get rid of
the hardwired hackery in tsc.c. The flag change is just used for this
and can be extended for other purposes.

	tglx


