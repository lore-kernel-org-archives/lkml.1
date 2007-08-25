Return-Path: <linux-kernel-owner+w=401wt.eu-S934647AbXHYTla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647AbXHYTla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 15:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbXHYTlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 15:41:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38124 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765028AbXHYTlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 15:41:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [PATCH -mm 2/2] Hibernation: Arbitrary boot kernel support on x86_64
Date: Sat, 25 Aug 2007 21:51:53 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708241206.57178.rjw@sisk.pl> <200708252027.26721.rjw@sisk.pl> <Pine.LNX.4.64.0708251132070.22470@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0708251132070.22470@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708252151.54969.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 25 August 2007 20:32, david@lang.hm wrote:
> On Sat, 25 Aug 2007, Rafael J. Wysocki wrote:
> 
> > On Friday, 24 August 2007 22:46, Pavel Machek wrote:
> >> Hi!
> >>
> >>> From: Rafael J. Wysocki <rjw@sisk.pl>
> >>>
> >>> Make it possible to restore a hibernation image on x86_64 with the help of a
> >>> kernel different from the one in the image.
> >>>
> >>> The idea is to split the core restoration code into two separate parts and to
> >>> place each of them in a different page.  The first part belongs to the boot
> >>
> >> What happens in case where both parts want to be
> >> at the same place? (Like kernel being restored is 4KB smaller, so that
> >> routines now collide?)
> >
> > Bad things, but I can't see how to avoid that reliably.
> 
> can you at least detect it reliably? (feed a program both kernel images 
> and have it tell you 'yes/no')

Well, I have an idea how to handle that, but I need to test it.  Stay tuned. :-)

Greetings,
Rafael
