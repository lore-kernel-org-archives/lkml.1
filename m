Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbXEaRjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbXEaRjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbXEaRjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:39:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:53706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbXEaRjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:39:31 -0400
Message-ID: <465F07F0.3000406@cv-sv.de>
Date: Thu, 31 May 2007 19:37:52 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.4) Gecko/20070529 SUSE/1.1.2-4.1 SeaMonkey/1.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Dave Jones <davej@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Christian Volkmann <haveaniceday@cv-sv.de>, ak@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC: 2.6 patch] i386: remove support for the Rise CPU
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <464BB252.8010008@cv-sv.de> <464CC8E1.5010407@cv-sv.de> <20070517214754.GC398@redhat.com> <20070531052238.GX3899@stusta.de> <20070531133106.GA26030@redhat.com>
In-Reply-To: <20070531133106.GA26030@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+7PGOp85ow037VGFzJZXS7USGGAMSOi5W709R
 rR/LMyYqXIuVGnVJ9u7mjj6O4tKfJVfI9MjXGPLR4Ev8x71Slh
 H6orWi2i3kVjF3Glf7Yhw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The SIS550 chip uses the mP6 core according to http://en.wikipedia.org/wiki/MP6
May be this code can improve the capability of these SIS550 system on a chip ?

But this should be a different story.

Dave Jones wrote:
> On Thu, May 31, 2007 at 07:22:38AM +0200, Adrian Bunk wrote:
>  > On Thu, May 17, 2007 at 05:47:54PM -0400, Dave Jones wrote:
>  > > On Thu, May 17, 2007 at 11:28:01PM +0200, Christian Volkmann wrote:
>  > > 
>  > >  > - Important: somebody to check other CPU types if the same behavior happens.
>  > > 
>  > > arch/i386/kernel/cpu/rise.c
>  > > 
>  > > Though, I've *never* seen or even heard of someone with one of those CPUs,
>  > > so whether we need to care is questionable. The mp6 did actually make it
>  > > to manufacture aparently, but I don't think anyone actually bought one.
>  > > http://en.wikipedia.org/wiki/Rise_Technology for a pic of this mythical beast.
>  > 
>  > Considering that arch/i386/kernel/cpu/rise.o takes a few bytes in every 
>  > i386 kernel image, what about removing it?
> 
> I'll be amazed if someone complains.
> We'll still boot fine on those CPUs without that support code too,
> we just won't advertise cx8 to userspace, and /proc/cpuinfo
> won't prettyprint the name. whoopdy-do.
> 
> Should we actually find someone who a) has one and b) is crazy enough
> to still run it today, we could always add this stuff back.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> 	Dave
> 

