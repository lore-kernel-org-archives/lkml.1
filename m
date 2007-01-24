Return-Path: <linux-kernel-owner+w=401wt.eu-S965617AbXAXCRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965617AbXAXCRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965620AbXAXCRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:17:49 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:62316 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965617AbXAXCRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:17:48 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070123211159.178138000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 23 Jan 2007 18:16:31 -0800
Message-Id: <1169604991.19471.95.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-23 at 22:00 +0000, Thomas Gleixner wrote:
>  - Provide a generic way to verify clocksources. TSC needs
>    verification due to broken hardware and BIOS implementations. The
>    previous attempt to allow TSC usage for high resolution and/or
>    dynamic ticks only in combination with the PM-Timer made hardwired
>    assumptions, which are ugly to maintain. The new verification code
>    solves this by chosing the best available clocksource for
>    verification and handles the usability check for highres / dynamic
>    ticks. This makes TSC code agnostic of other hardware available in
>    the system.


There appears to be some fairly clear duplication between my clocksource
tree and this release of high resolution timers. Not to mention that we
both submitted our tree's to Andrew within days . 

To lessen Andrews burden it would be wise to integrate the two trees
prior to anything going into -mm .. It makes sense to eliminate this
kind of duplication since it just results in wasted effort. With the
benefit that the merge would likely result in a stronger patch set over
all.

Daniel

