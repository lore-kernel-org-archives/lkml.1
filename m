Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbXD0V0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbXD0V0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbXD0VZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:25:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58672 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334AbXD0VZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:25:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: Back to the future.
Date: Fri, 27 Apr 2007 23:24:42 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177654110.4737.91.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704272324.43359.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 April 2007 08:18, Pekka J Enberg wrote:
> On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> > COW is a possibility, but I understood (perhaps wrongly) that Linus was
> > thinking of a single syscall or such like to prepare the snapshot. If
> > you're going to start doing things like this, won't that mean you'd then
> > have to update/redo the snapshot or somehow nullify the effect of
> > anything the programs does so that doing it again after the snapshot is
> > restored doesn't cause problems?
> 
> No. The snapshot is just that. A snapshot in time. From kernel point of 
> view, it doesn't matter one bit what when you did it or if the state has 
> changed before you resume. It's up to userspace to make sure the user 
> doesn't do real work while the snapshot is being written to disk and 
> machine is shut down.

Why do you think that keeping the user space frozen after 'snapshot' is a bad
idea?  I think that solves many of the problems you're discussing.

Greetings,
Rafael

