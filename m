Return-Path: <linux-kernel-owner+w=401wt.eu-S968181AbXFHMjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968181AbXFHMjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 08:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937736AbXFHMjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 08:39:37 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57099 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937708AbXFHMjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 08:39:36 -0400
Date: Fri, 8 Jun 2007 14:39:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jcm@jonmasters.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070608123942.GZ5500@stusta.de>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com> <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr> <20070607193413.GR5500@stusta.de> <20070607232248.332edee8@the-village.bc.nu> <20070607232152.GU5500@stusta.de> <20070608004117.57868755@the-village.bc.nu> <20070608000455.GW5500@stusta.de> <20070608115219.694c642d@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070608115219.694c642d@the-village.bc.nu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 11:52:19AM +0100, Alan Cox wrote:
> > The problem is that the second byte is interpreted as a control code.
> > 
> > Is there any trick to get the shell working again in this situation?
> > The cursor hangs, and I've not yet found a trick to do anything in this
> > xterm again (except for killing it from another xterm).
> 
> For gnome terminal just select 'reset terminal' in the menu or escape-[c;
>  (from memory) is the VT reset code. If your xterm can be stuck forever
> file a security bug against your vendors xterm for a DoS attack problem.

Someone else already told me this trick, and the "Full Reset" from the 
Control + middle mouse button menu works with my xterm.

Not a problem if you know about it or if you have time.

> > > "Require" is a rather strong word for a print formatting issue specific
> > > to obscure setups.
> > 
> > See obove, it's not only "print formatting", it's "kills my shell".
> 
> It printed a symbol, if your shell really got screwed that much by it
> then your shell needs work perhaps.

My shell is bash...

> I'm not btw arguing that we shouldn't
> teach the tools to be more polite, just that its hardly a "requirement"

For tools like ls or vim that have to deal with every kind of charset 
confusion for ages such issues have already been shaken out.

But tools don't expects the kernel to output non-ASCII strings.

It's not only about MODULE_AUTHOR, if you consider it rude to limit 
people's names to ASCII, then don't forget that we have printk's like
    Linux agpgart interface v0.102 (c) Dave Jones

What happens if the maintainer changes and it's now
     Linux agpgart interface v0.103 © Dave Ønes

Does the console handle it correctly during boot?
Can all tools that process the syslog cope with it?

Perhaps the answer is in both cases "yes", but it's a completely 
untested area.

We really must have all bugs shaken out and all users using fixed tools 
_before_ we can start outputting UTF-8 - limiting people's names to 
ASCII in not ideal, but IMHO causing breakages for users is a much 
bigger problem.

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

