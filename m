Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbZGIB3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbZGIB3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 21:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbZGIB24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 21:28:56 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:60587 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756665AbZGIB2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 21:28:55 -0400
From: Frans Pop <elendil@planet.nl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
Date: Thu, 9 Jul 2009 03:28:52 +0200
User-Agent: KMail/1.9.9
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <200907080700.33120.elendil@planet.nl> <21d7e9970907081642l3ef6df5blde31df656cd74432@mail.gmail.com>
In-Reply-To: <21d7e9970907081642l3ef6df5blde31df656cd74432@mail.gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907090328.53643.elendil@planet.nl>
X-OriginalArrivalTime: 09 Jul 2009 01:28:53.0882 (UTC) FILETIME=[9EF7CDA0:01CA0034]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 July 2009, Dave Airlie wrote:
> > [1] I'd even go so far as to feel it should be a standard test case
> > for video driver developers, given that this is the third time it's
> > shown regressions :-) For the third case the bug was in the X.Org
> > i830 driver: http://bugs.freedesktop.org/show_bug.cgi?id=14481.
>
> It might surprise you to learn this, but vesafb has never been
> considered supportable by the X.org community, and you'll notice not
> very many distros ship with it enabled, it breaks suspend/resume on
> many machines for example.

I beg to disagree.
- Debian does have it enabled by default.
- I have always used it on all my machines without any problems.
- Both my laptops and my desktop suspend and resume perfectly with vesafb
  and X.Org.
- Jesse Barnes seems to disagree with you. To quote from the BR cited
  above (comment #11): "and you're right, making things work with vesafb
  isn't unreasonable".

I do know intelfb is considered to be terminally broken, but have always 
understood the use of vesafb to be accepted.

> As I said having two drivers thinking they own the GPU is a recipe for
> total disaster and thats why we've designed the new KMS code so you can
> get cool bootup logos and avoid the insanity dance.

Yes, and I really welcome the great progress being made there. But for me 
it's not yet an option as I run Debian stable on these boxes.

> However we shall endeavour to fix this issues as it may be systemic of
> something else going wrong in the new PAT/AGP code.

Great. Thanks in advance, I do appreciate it.

BTW, today I noticed another regression, but I have not yet looked into it 
deeply. When I suspend I normally see at least some console messages from 
the suspend procedure on the framebuffer console, but with .31-rc2 I only 
see a cursor. It does not really affect the suspend/resume.
Could possibly be related. Will investigate further.

Cheers,
FJP
