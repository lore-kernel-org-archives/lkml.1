Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbXHPM3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbXHPM3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 08:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757755AbXHPM2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 08:28:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50122 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbXHPM2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 08:28:52 -0400
Date: Thu, 16 Aug 2007 18:11:17 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: =?iso-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Joe Perches <joe@perches.com>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, rolandd@cisco.com,
       Chas Williams <chas@cmf.nrl.navy.mil>, Paul Mundt <lethal@linux-sh.org>,
       isdn4linux@listserv.isdn4linux.de, mikep@linuxtr.net,
       Netdev <netdev@vger.kernel.org>, swen@vnet.ibm.com, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, jdike@karaya.com,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net,
       netfilter-devel@lists.netfilter.org, coreteam@netfilter.org
Subject: Re: drivers/infiniband/mlx/mad.c misplaced ;
In-Reply-To: <Pine.LNX.4.64.0708161248050.22579@kivilampi-30.cs.helsinki.fi>
Message-ID: <alpine.LFD.0.999.0708161801530.25951@enigma.security.iitk.ac.in>
References: <20070815235825.GB17004@redhat.com> <1187224811.5906.55.camel@localhost>
 <20070816084635.GA15985@osiris.boeblingen.de.ibm.com>
 <Pine.LNX.4.64.0708161248050.22579@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1168800151-1187268086=:25951"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1168800151-1187268086=:25951
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT

Hi Ilpo,


On Thu, 16 Aug 2007, Ilpo Järvinen wrote:

> 
> ...I guess those guys hunting for broken busyloops in the other thread 
> could also benefit from similar searching commands introduced in this 
> thread... ...Ccing Satyam to caught their attention too.
> 
> 
> > On Wed, Aug 15, 2007 at 05:40:11PM -0700, Joe Perches wrote:
> > > 
> > > There's more than a few of these (not inspected).
> > > 
> > > $ egrep -r --include=*.c "\bif[[:space:]]*\([^\)]*\)[[:space:]]*\;" * 
> 
> ...Hmm, I plugged in "a preprocessor" too to manage with non compliant 
> coding styles :-). Please understand that the line numbers are not an 
> exact match due to preprocessor changes:
> 
> $ for i in `find . -name '*.[ch]'`; do echo $i; indent -npro -kr -i8 -ts8 
> -sob -l8000 -ss -ncs -cp1 -nhnl -st $i | egrep -n "[[:space:]]if [(].*[)] ;$";
> done | grep -B1 "^[^.]"

Thanks, looks useful, will check with this.


Satyam
--464262402-1168800151-1187268086=:25951--
