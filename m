Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbZJLXzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbZJLXzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbZJLXzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:55:06 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:48995 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbZJLXzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:55:04 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 19:55:04 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FJ9yt2lga45yD7jxQMtguddtJiDdpM02Dg97ORjzHXIJWcQbSyK2hTKEyZkBAXKU6g
         eV9uBmmpb+pzHTF11YSENpAr7He2u0vwd4jmT4C8+CFMAI6wH8eZLrVOvOzfUx8D8LsQ
         os3lEMddFnGyJ/WsX1UNbe2hzMdy/ywqZufBc=
Date: Mon, 12 Oct 2009 16:46:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nix <nix@esperi.org.uk>, "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>, Ed Tomlinson <edt@aei.ca>,
       =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier <fredlwm@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091012234641.GF8345@core.coreip.homeip.net>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <20091013003841.6c2988d0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013003841.6c2988d0@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 12:38:41AM +0100, Alan Cox wrote:
> > So it seems likely to me that this is a kernel bug, somewhere, and the
> > TTY layer seems like a good place to look (OK, a horrible place, but a
> > *likely* place).
> 
> Somewhere around 2.6.29-30 various things went funny in the keyboard
> layer for me - notably characters "bleeding" across console switches.
> 

What do you mean by "bleeding"? Are you sure it is not autorepeat
kicking in?

> > 
> > I'm about to try reverting the suggested commit and will report back. I
> > see this failure about once a day, so I'll give it three days to go
> > wrong and then (if it doesn't) will presume it works and so inform you.
> > 
> > 
> > (Of course with this commit reverted Emacsen start dropping data from
> > their ptys, and as bad luck would have it I live in (X)Emacs, but that's
> > on a different machine! so I can have my compile buffer data *and* not
> > destroy X ;} )
> 
> X doesn't touch the pty layer. It touches vt (extensively) and the input
> layers. It's vt/kbd access is also very raw so bypasses much of that
> layer. That isn't to say tty isn't the cause but look for input layer
> changes too.

-- 
Dmitry
