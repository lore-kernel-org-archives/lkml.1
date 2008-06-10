Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbYFJQ6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbYFJQ6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYFJQ6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:58:41 -0400
Received: from smtp1.riverbed.com ([206.169.144.12]:50907 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYFJQ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:58:41 -0400
Date: Tue, 10 Jun 2008 09:58:25 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Doug Thompson <norsk5@yahoo.com>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>
Subject: Re: on static kobjects and double frees...
Message-ID: <20080610165825.GB28572@ajones-laptop.nbttech.com>
References: <20080610155848.GS26334@ajones-laptop.nbttech.com> <20080610162341.GA13538@kroah.com> <20080610163800.GA28572@ajones-laptop.nbttech.com> <20080610164241.GA13928@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080610164241.GA13928@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, ...

On Tue, Jun 10, 2008 at 09:42:41AM -0700, Greg KH wrote:
> > [...]
> > OK, I wondered about this, but I didn't see anything
> > in Documentation/kobject.txt that said that kobjects
> > can not be static.  But now that I've fixed the double
> > free bug, I'm seeing the warning you mentioned above...
> 
> Hm, there is the following text in that file:
>         Because kobjects are dynamic, they must not be declared
>         statically or on the stack, but instead, always allocated
>         dynamically.  Future versions of the kernel will contain a
>         run-time check for kobjects that are created statically and will
>         warn the developer of this improper usage.

Indeed, I see that now.  Sorry for the noise, I should
have read more carefully...

> > I don't know how the current code came to be, so I
> > can't speak to your issues below.  But, with these
> > pointers, I think I can get things cleaned up properly.
> 
> Great, if you want me to review it, I'd be glad to do so.

Thanks!

Arthur
