Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbZFKQfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbZFKQfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZFKQfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:35:00 -0400
Received: from senator.holtmann.net ([87.106.208.187]:34104 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZFKQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:35:00 -0400
Subject: Re: [GIT PULL] Performance Counters for Linux
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu>
	 <20090611161714.GA5008@infradead.org>
	 <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 18:34:58 +0200
Message-Id: <1244738098.27363.36.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > Err, no.   This adds tons of userspace code into tools/ which
> > should not be in the kernel tree but a proper package.
> 
> I disagree.
> 
> We've had tons of cases where we tried to "separate" the user-land code 
> and the kernel code, in the name of "beauty" of whatever.
> 
> It's almost invariably a disaster.
> 
> Look at oprofile. F*ck me, what a horrid piece of crap. It took literally 
> months for the user mode tools to catch up and get the patches to support 
> new functionality into CVS (or is it SVN?), and after that it took even 
> longer for them to become part of a release and be picked up by 
> distributions. In fact, I'm not sure it is part of a release even now - I 
> had to make a bug report to Fedora to get atom and Nehalem support in my 
> tools: I think they took the unofficial patch.
> 
> Or look at the crazy things we used to do for X. It's going away (slowly), 
> because some of the most incestuous things are actually just being 
> integrated into the kernel, and so there's less of the "two broken pieces" 
> approach, and more of a "one working piece" kind of thing.
> 
> So I'd much rather have kernel tools with the kernel, than have to depend 
> on some external entity that doesn't really care.

so do you expect us to merge stuff like ip, iw, rfkill, crda, the WiMAX
tools, the Bluetooth ones and whatever we have that are all have the
same issues to be merged into the kernel source code as well.

I see no reason this can't be maintained properly outside the kernel
source. You will always have bad sheeps and screw-ups, but just putting
everything into one single location is not a good idea either. Other
subsystems do this well and so could Ingo.

Also please consider the distro point of view. All these distros have
already a hard time to keep up with the kernel patches etc. It is a lot
easier to update a userspace package then having to provide a patches
kernel source.

Regards

Marcel


