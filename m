Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930Ab0ASSMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab0ASSMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 13:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254Ab0ASSMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 13:12:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab0ASSMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:12:47 -0500
Date: Tue, 19 Jan 2010 19:12:20 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Mike Frysinger <vapier.adi@gmail.com>
cc: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: dont hardcode path to lsmod
In-Reply-To: <8bd0f97a1001190954q62b3bc5ejbdb69684d61c087c@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001191900340.5999@localhost.localdomain>
References: <1263883920-17289-1-git-send-email-vapier@gentoo.org>  <20100119142545.GB3473@hack> <8bd0f97a1001190923p6104acb4if5ec7225d549b713@mail.gmail.com>  <520f0cf11001190942n2c765618m8a66b8afe82010d0@mail.gmail.com>
 <8bd0f97a1001190954q62b3bc5ejbdb69684d61c087c@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1134034143-1263924744=:5999"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1134034143-1263924744=:5999
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Tue, 19 Jan 2010, Mike Frysinger wrote:

> On Tue, Jan 19, 2010 at 12:42, John Kacur wrote:
> > On Tue, Jan 19, 2010 at 6:23 PM, Mike Frysinger wrote:
> >> On Tue, Jan 19, 2010 at 09:25, Américo Wang wrote:
> >>> On Tue, Jan 19, 2010 at 01:52:00AM -0500, Mike Frysinger wrote:
> >>>>The lsmod utility has always been installed into /bin with the newer
> >>>>module-init-tools package, so let lsmod be found via PATH instead of
> >>>>hardcoding the old modutils /sbin path.
> >>>>
> >>>
> >>> Some distro doesn't set /sbin to PATH, so for me a better solution
> >>> would be making PATH contain /sbin, and then use "lsmod".
> >>
> >> read my changelog -- module-init-tools has always installed into /bin.
> >>  so what your distro does with /sbin doesnt matter.
> >
> > I prefer my patches work for the real-world instead of the "so what
> > your distro does doesn't matter" world.
> 
> try reading my comment instead of getting huffy.  if you have a distro
> that does something stupid like break the correct default m-i-t
> install setup, you should actually point it out.  the ones i checked
> were sane and installed lsmod into /bin (and some symlinked lsmod for
> backwards compat with modutils into /sbin).
> -mike

Well, I'm currently running Fedora (10 thru 12), and lsmod is in /sbin
Your patch would still not break for me because /sbin is in the PATH.

However if Américo is correct that there are distros that have lsmod in
/sbin and don't have /sbin in the PATH, then your patch would break them.
You can argue that the distro is doing something stupid, but I'll bet you
they will blame your patch for breaking them. It seems reasonable to 
me that a distro might only put /sbin in the superuser path, so I can 
imagine there are cases like Américo suggests.

Thanks.
--8323328-1134034143-1263924744=:5999--
