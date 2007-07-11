Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXGKKnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXGKKnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759108AbXGKKnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:43:14 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:35636 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386AbXGKKnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:43:13 -0400
To: rjw@sisk.pl
CC: a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu, pavel@ucw.cz,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-reply-to: <200707111227.52609.rjw@sisk.pl>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <46940F45.3090005@goop.org> <200707110711.26767.a1426z@gawab.com> <200707111227.52609.rjw@sisk.pl>
Message-Id: <E1I8Ze4-0008OM-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Jul 2007 12:42:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Yes, I suppose.  You're certain the old kernel's devices are completely
> > > quiescent at that point?
> > 
> > That's exactly the problem; trying to save a state from within the
> > kernel would probably necessitate a freezer hack, which we are
> > trying so dearly to avoid.
> 
> Well, I don't think that avoiding the freezer whatever it takes
> would be a good idea.  There needs to be some balance. ;-)

Well, it takes some extra locking in the drivers.  Which is needed
_anyway_ if we want to have a working s2ram without the freezer.

With the kexec approach, I don't see any extra requirements from the
kernel to be able to drop the freezer.

Miklos
