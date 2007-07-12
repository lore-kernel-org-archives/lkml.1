Return-Path: <linux-kernel-owner+w=401wt.eu-S935878AbXGLCx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935878AbXGLCx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbXGLCxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:53:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37045 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759667AbXGLCxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:53:48 -0400
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.999.0707111557150.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	 <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
	 <1184191488.12353.160.camel@chaos>
	 <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org>
	 <20070711225139.GB4306@sequoia.sous-sol.org>
	 <alpine.LFD.0.999.0707111557150.20061@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 12 Jul 2007 10:53:19 +0800
Message-Id: <1184208799.2693.15.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 15:58 -0700, Linus Torvalds wrote:
> 
> On Wed, 11 Jul 2007, Chris Wright wrote:
> > 
> > That's not quite right.  Leaving the code unchanged caused breakage
> > already.  The PIT is damn stupid and can be sensitive to how quickly it's
> > programmed.  So code that enable/disable didn't change, but frequency
> > with which it is called did and broke some random boxes.
> 
> Sure. We cannot avoid *all* problems. Bugs happen. 
> 
> But at least we could try to make sure that there aren't totally 
> unnecessary changes in that switch-over patch. Which there definitely 
> were, as far as I can tell.


one note is that the "talk differently to hardware" thing is in part
already tested with the 32 bit tickless code; a lot of people (80% ?)
are still using the 32 bit OS on their 64 bit machines, and the 32 bit
code already talks in the "new way" to this hardware.... 
(and since Fedora 7 already ships tickless for 32 bit there are quite a
lot of people using that in practice, in addition to the kernel.org
kernel users)

I would expect just about all the hardware interaction issues to have
popped up already because of this "run 32 bit on 64 bit hardware" thing.
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

