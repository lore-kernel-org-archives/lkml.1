Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZDTEks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZDTEks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 00:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZDTEkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 00:40:39 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42795 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZDTEki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 00:40:38 -0400
Date: Mon, 20 Apr 2009 06:42:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT] kbuild
Message-ID: <20090420044242.GA8494@uranus.ravnborg.org>
References: <20090419092555.GA19213@uranus.ravnborg.org> <20090419223959.GB12054@linux-sh.org> <20090419234501.GA6475@uranus.ravnborg.org> <alpine.LFD.2.00.0904191745390.2199@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904191745390.2199@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 05:52:32PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 20 Apr 2009, Sam Ravnborg wrote:
> > 
> > You will soon see a path from me where I fix sh too.
> 
> Can we do a global 'sed s:asm/asm-offsets.h:generated/asm-offsets.h:g' 
> thing too? And then get rid of the include/asm symlink?

As Al also suggest I did a one-asm-offsets.h file per arch so we
can cnvert them one by one.

> That asm-offsets.h mess is scary. I don't quite know why kvm on ia64 seems 
> to do it's own asm-offsets.h file, for example.
Will take a look.

> And arch/blackfin/Makefile 
> mentions arch/$(ARCH)/include/asm/asm-offsets.h (but does it actually do 
> one?).
Thats just a left over from older days when the arch's had to clean up after
themself.

I will try to finish something within a few days and send it out for review.

	Sam
