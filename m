Return-Path: <linux-kernel-owner+w=401wt.eu-S1764436AbXGKM43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764436AbXGKM43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbXGKM4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:56:22 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:33046 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642AbXGKM4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:56:22 -0400
To: nigel@suspend2.net
CC: miklos@szeredi.hu, rjw@sisk.pl, a1426z@gawab.com, jeremy@goop.org,
       jbms@cmu.edu, pavel@ucw.cz, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <200707112246.54510.nigel@nigel.suspend2.net> (message from Nigel
	Cunningham on Wed, 11 Jul 2007 22:46:50 +1000)
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <200707112211.23420.nigel@nigel.suspend2.net> <E1I8bEi-0000HF-00@dorka.pomaz.szeredi.hu> <200707112246.54510.nigel@nigel.suspend2.net>
Message-Id: <E1I8bjM-0000NS-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Jul 2007 14:55:44 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The point to freezing tasks isn't just to stop drivers doing work. It's also 
> to stop userspace doing work and thereby increase reliability. The more work 
> that is occuring while we're trying to write a hibernation image, the less 
> reliable the hibernation will be (competing for memory and so on) and the 
> slower it will be (competing for cycles etc).

We are talking about a kexec based hibernate.  All of the above just
doesn't apply in that case.

I'm not contending, that the current hibernation (epecially Pavel's
new userspace based one) needs a frozen userland.

> > > Why? How can such ordering be determined programmatically?
> > 
> > It can't.  If you are interested, please read through that thread.  If
> > something's still not clear, let's discuss it further.
> 
> You can say it "imposes certain ordering" but you can say what that ordering 
> is?! How about mount order? That must be a good start.

The order in which tasks are relying on each other to be able to
finish a syscall.

Mount order says _nothing_ about tasks.

Miklos
