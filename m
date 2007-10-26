Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbXJZP7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbXJZP7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXJZP7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:59:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56983 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbXJZP7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:59:39 -0400
Date: Fri, 26 Oct 2007 08:58:33 -0700
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
Message-ID: <20071026155833.GF23016@kroah.com>
References: <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4721B77F.8070102@imap.cc>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 11:46:39AM +0200, Tilman Schmidt wrote:
> On Thu, 25 Oct 2007 19:56:47 -0700, Greg KH wrote:
> > I'm trying to compile a list of all known external modules and drivers
> > and work to get them included in the main kernel tree to help prevent
> > these kinds of things.  If you know of any that are not on the list at:
> > 	http://linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
> > please feel free to add them, or email me with the needed information
> > and I will add them to the list.
> 
> That's certainly helpful, but I still think there will always be
> a number of external modules that cannot be merged right now or at
> all, and deliberately making life difficult for out-of-tree code
> maintainers in order to coerce them into submitting their code for
> inclusion in the kernel will not work, it'll only create bad
> feelings.

Do you have examples of proof of this?  Read
Documentation/stable_api_nonsense.txt for how we already make
out-of-tree code developer's lives hell :)

thanks,

greg k-h
