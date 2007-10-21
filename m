Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbXJUW7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbXJUW7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 18:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXJUW7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 18:59:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39759 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750872AbXJUW7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 18:59:17 -0400
Date: Mon, 22 Oct 2007 00:59:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: James Morris <jmorris@namei.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LSM conversion to static interface
Message-ID: <20071021225946.GF30533@stusta.de>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com> <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org> <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 08:57:06AM +1000, James Morris wrote:
> On Sat, 20 Oct 2007, Jan Engelhardt wrote:
> 
> > >I'd like to note that I asked people who were actually affected, and had 
> > >examples of their real-world use to step forward and explain their use, 
> > >and that I explicitly mentioned that this is something we can easily 
> > >re-visit.
> > 
> > I do have a pseudo LSM called "multiadm" at 
> > http://freshmeat.net/p/multiadm/ , quoting:
> 
> Based on Linus' criteria, this appears to be a case for reverting the 
> static LSM patch.
>...

If you take it that strictly, the in-kernel root_plug LSM could have 
been considered enough reason for reverting...

The interesting question is IMHO still:

Were Greg and Jan the only people to write such LSMs, or how many 
non-abusive users that make sense as modules do really exist after
5 years?

Either you can count such real-world users with your fingers or there's 
a reason why these modules didn't get included.

IOW:
Either the API has proven to not attract enough modular users or we are 
having a to-be-fixed problem with getting the LSMs submitted and 
included.

> - James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

