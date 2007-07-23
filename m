Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbXGWNxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbXGWNxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXGWNxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:53:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49584 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbXGWNxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:53:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>, stern@rowland.harvard.edu
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Mon, 23 Jul 2007 16:01:07 +0200
User-Agent: KMail/1.9.5
Cc: oliver@neukum.org, nigel@nigel.suspend2.net, nigel@suspend2.net,
       jbms@cmu.edu, miltonm@bga.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org> <200707231431.30372.oliver@neukum.org> <E1ICxdo-0004w2-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1ICxdo-0004w2-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707231601.09541.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23 July 2007 15:08, Miklos Szeredi wrote:
> > > > The reason is that we want them to "park" in safe places, ie. where there
> > > > are no locks held etc.  Thus, these safe places need to be chosen somehow
> > > > and since they are not marked throughout the code, we choose the obvious
> > > > one. :-)
> > > 
> > > Why shouldn't locks be held?
> > > 
> > > No locks which are required for suspend must be held, sure.  But
> > > otherwise holding locks doesn't matter at all.
> > 
> > If you can provide a way to tell them apart, this would work.
> 
> Without some marking we can't tell obviously.
> 
> Are there many such locks?  We can easily check by adding some
> debugging code to the lock primitives, to make them yell if they are
> used during suspend.

This way we can only obtain information from systems that use hibernation
quite often.

Alan has recently proposed to introduce "suspend locks" to be acquired during
a suspend/hibernation and such that we can leave uninterruptible tasks that
don't hold any of them.

Unfortunately, I have no link to his original message at hand.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
