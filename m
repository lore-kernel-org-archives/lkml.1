Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbYHTWzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbYHTWzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 18:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYHTWyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 18:54:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbYHTWyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 18:54:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [OT] 'git pull' from Linus' tree doesn't work for me any more
Date: Thu, 21 Aug 2008 00:58:06 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200808210045.42693.rjw@sisk.pl> <alpine.LFD.1.10.0808201548300.3487@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808201548300.3487@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210058.06515.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of August 2008, Linus Torvalds wrote:
> 
> On Thu, 21 Aug 2008, Rafael J. Wysocki wrote:
> > 
> > Does anybody else see something like this after the latest push from Linus:
> > 
> > ~/devel/linux-2.6> git pull
> > fatal: The remote end hung up unexpectedly
> > Cannot get the repository state from git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > 
> > I see this on two different machines.
> 
> It might easily be just a temporary glitch in the matrix.
> 
> It happens sometimes because the kernel.org machines use rsync to 
> synchronize with each other, and since it's not really a git-aware 
> protocol, rsync might copy the branch files _before_ it copies the object 
> files.
> 
> It starts working after a few minutes when the rsync has completed.

Well, it hasn't been working for a couple of hours now ...

Rafael
