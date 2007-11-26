Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbXKZIH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbXKZIH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXKZIHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:07:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbXKZIHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:07:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Dave Jones <davej@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 23/27] x86: debugctlmsr kconfig
In-Reply-To: Dave Jones's message of  Sunday, 25 November 2007 20:57:57 -0500 <20071126015757.GA16807@redhat.com>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
	<20071125220802.76C2F26F8C5@magilla.localdomain>
	<20071126015757.GA16807@redhat.com>
X-Shopping-List: (1) Zealous fads
   (2) Vacuous venomous potions
   (3) Piteous vivacious omissions
Message-Id: <20071126080644.44F3726F8C5@magilla.localdomain>
Date: Mon, 26 Nov 2007 00:06:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What about the non-Intel vendors ?
> Was this msr present on AMD K6 ? Geode? Winchip? VIA C3 ?
> If not, then this patch isn't complete. 

I know modern AMD processors have it.  I don't know about any others, nor
off hand where to look to find out.  Is there a better way to compose the
"depends on" condition so that it will be true on the modern common
processors and future common flavors, but false on the various ones we
don't know about?  (I really just looked around a little and figured that
!X86_F00F_BUG about corresponded to "P6 family".)


Thanks,
Roland
