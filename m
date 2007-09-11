Return-Path: <linux-kernel-owner+w=401wt.eu-S933696AbXIKVvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbXIKVvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbXIKVve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:51:34 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37615 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753232AbXIKVvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:51:33 -0400
Date: Tue, 11 Sep 2007 23:51:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-ID: <20070911215140.GV3563@stusta.de>
References: <20070911201219.GA9674@uranus.ravnborg.org> <200709112138.11247.ak@suse.de> <20070911211422.GU3563@stusta.de> <200709112234.24155.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200709112234.24155.ak@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 10:34:23PM +0100, Andi Kleen wrote:
> 
> >
> > People do not expect code under arch/i386/ to be used by code under
> > arch/x86_64/ and vice versa.
> >
> > That regularly results in people sending patches that don't compile on
> > the other architecture.
> >
> > With one architecture it's much more obvious that the code is shared.
> 
> Will that cause people to compile test both? I have my doubts that 
> will really work.
>...

You will see that it could be shared, and it'll be much easier to see 
all configurations it's used in.

Currently, there are 6 or 7 different ways how a function under 
arch/i386/ could be used by a function under arch/x86_64/ (and vice 
versa) and it's non-trivial to figure out all usages when grep'ing for 
users.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

