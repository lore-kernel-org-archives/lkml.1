Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbXJXR3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbXJXR3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbXJXR24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:28:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40862 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbXJXR2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:28:55 -0400
Date: Wed, 24 Oct 2007 18:17:52 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, davej@codemonkey.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: [2.6 patch] #if 0 cpufreq.c:cpufreq_get()
Message-ID: <20071024171751.GG32333@flint.arm.linux.org.uk>
References: <20071024162312.GH30533@stusta.de> <20071024093839.232e5cd5@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024093839.232e5cd5@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 09:38:39AM -0700, Arjan van de Ven wrote:
> On Wed, 24 Oct 2007 18:23:12 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > cpufreq.c:cpufreq_get() no longer has any user.
> > 
> 
> it's... also a really bad/buggy interface... frquency is a per cpu
> property for one, and constantly changing (esp in a multi-core world)
> even depending on what other parts of the system are doing.

... and such an assumption which would make it impossible to use
the LCD controller on StrongARM-11x0 processors.

This is precisely why we have CPUFREQ - so that hardware which needs
to be re-timed when the CPU frequency changes can get notified of that
event and take the appropriate action.  It exists.  It works.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
