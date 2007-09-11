Return-Path: <linux-kernel-owner+w=401wt.eu-S966643AbXIKUe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966643AbXIKUe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758299AbXIKUeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:34:07 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:50830 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932769AbXIKUeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:34:05 -0400
Date: Tue, 11 Sep 2007 22:34:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-ID: <20070911203412.GS3563@stusta.de>
References: <20070911201219.GA9674@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070911201219.GA9674@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 10:12:19PM +0200, Sam Ravnborg wrote:
>...
> In a meged x86 tree it would be very beneficial to either include
> in the filename that a specific file is i386 or x86_64 specific or
> stuff them in a separate subdirectory.
> 
> If legacy.c numa.c, pcibios.c and visws.c placed in a directory named i386
> then it would be obvious that this is i386 only.
> Or they could be named filename_32 (or the uglier filename_i386).
> As it stands out today the filename are kept but thier relationship are lost.
>...

I'm not agreeing with you on this.

It seems artificial to think 32bit<->64bit was the only interesting 
distinction on x86 machines.

You might as well create different directories for i386<->i486+ or
pre-i686<->i686+.

As an example, visws.c is as much non-64bit as it is pre-i686.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

