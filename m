Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbYIKSYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbYIKSYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYIKSYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:24:36 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:45836 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbYIKSYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:24:35 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Date: Thu, 11 Sep 2008 20:24:29 +0200
User-Agent: KMail/1.9.9
References: <48C68507.6000609@suse.com> <200809111832.38051.elendil@planet.nl> <alpine.LFD.1.10.0809111048340.3384@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809111048340.3384@nehalem.linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809112024.30747.elendil@planet.nl>
X-OriginalArrivalTime: 11 Sep 2008 18:24:33.0247 (UTC) FILETIME=[A35236F0:01C9143B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008, Linus Torvalds wrote:
> On Thu, 11 Sep 2008, Frans Pop wrote:
> > > Aren't _you_ the one who are ignoring current issues?
> >
> > I don't think so.
> > _The_ current issue for me is that I can no longer build Debian
> > kernel packages using 'make deb-pkg', which is part of _your_ tree,
> > and install the resulting package *NOW*.
>
> Well, complain to the right people then. The patch that started this
> all is wrong.

I totally agree with that.

What I would still like to see instead is the *option* to just include 
firmware inside modules, where it's always been.

Either that, or stop building firmware as part of the kernel build process 
altogether (which seems to be David's vision of the future).

> The people you are complaining to are not the rigth people. We can't do
> anything about debian packaging. 

This isn't about Debian packaging or Debian tools. I'm not using a Debian 
tool [1]! Why is that so hard to understand?

I'm using an option in *your* kernel tree that produces a broken Debian 
package. Please have a look in scripts/package/builddeb.
That offers the option to just do 'make deb-pkg' to build a kernel package 
in Debian package format.

The other part of my complaint is that this simple example proves that the 
firmware split *has* broken existing tools while you and others have been 
maintaining that everything would continue to work fine "because everyone 
has been using /lib/firmware for ages". The reason things have broken 
because we never used to generate files as a basically inseparable part 
of a kernel build before.


[1] I abandoned make-kpkg about a year ago because it was terminally 
insane and broken. AFAIK it still does not support the unified x86 dir...
