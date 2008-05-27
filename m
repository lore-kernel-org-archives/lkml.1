Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbYE0IzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbYE0IzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbYE0Iyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:54:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42286 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbYE0Iyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:54:54 -0400
Date: Tue, 27 May 2008 10:55:41 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, macro@ds2.pg.gda.pl
Subject: Re: i8259: fix final uglyness
Message-ID: <20080527085541.GA1708@elf.ucw.cz>
References: <20080520151528.GA1596@elf.ucw.cz> <20080520204750.GA31409@elte.hu> <20080521094402.GB12763@elf.ucw.cz> <alpine.LFD.1.10.0805222030050.3295@apollo.tec.linutronix.de> <20080522223232.GA1602@elf.ucw.cz> <alpine.LFD.1.10.0805271043220.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805271043220.3295@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-05-27 10:46:17, Thomas Gleixner wrote:
> On Fri, 23 May 2008, Pavel Machek wrote:
> 
> > 
> > Introduce IRQx_VECTOR on 32-bit, so that #ifdef noise is kept
> > down. There should be no object code change.
> 
> Pavel,
> 
> thanks for doing this. The patch fails due to other changes in this
> area (especially the hw_irq.h unification). Can you please redo against:
> 
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=shortlog;h=x86/irq
> 

Will redoing against linux-x86-tip work?

tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
