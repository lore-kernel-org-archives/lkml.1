Return-Path: <linux-kernel-owner+w=401wt.eu-S1763501AbXJZDgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763501AbXJZDgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXJZDg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:36:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60372 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbXJZDg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:36:26 -0400
Date: Thu, 25 Oct 2007 19:56:47 -0700
From: Greg KH <greg@kroah.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Adrian Bunk <bunk@kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
Message-ID: <20071026025647.GC21408@kroah.com>
References: <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4721221A.1020309@imap.cc>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 01:09:14AM +0200, Tilman Schmidt wrote:
> Am 25.10.2007 00:31 schrieb Adrian Bunk:
> > Generally, the goal is to get external modules included into the kernel.
> > [...] even though it might sound harsh breaking
> > external modules and thereby making people aware that their code should 
> > get into the kernel is IMHO a positive point.
> 
> This argument seems to start from the assumption that any externally
> maintained kernel code *can* get into the kernel, which doesn't stand
> up to  reality. Once you admit that there is code which, for very good
> reasons, won't ever be accepted into the mainline kernel tree, what you
> are saying amounts to: "Code that isn't fit to be included in the
> mainline kernel isn't fit to exist at all."

What kind of code is not accepted into the mainline kernel tree for good
reasons?  What are these reasons?  What specific code are you talking
about?

I'm trying to compile a list of all known external modules and drivers
and work to get them included in the main kernel tree to help prevent
these kinds of things.  If you know of any that are not on the list at:
	http://linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
please feel free to add them, or email me with the needed information
and I will add them to the list.

thanks,

greg k-h
