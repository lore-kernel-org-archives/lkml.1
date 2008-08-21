Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYHUMxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYHUMxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYHUMxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:53:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51787 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbYHUMxa (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:53:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Date: Thu, 21 Aug 2008 14:53:25 +0200
User-Agent: KMail/1.9.9
Cc: carsteno@de.ibm.com, jaredeh@gmail.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com
References: <48AD00C4.6060302@gmail.com> <48AD42AE.4030107@de.ibm.com> <200808212043.51209.nickpiggin@yahoo.com.au>
In-Reply-To: <200808212043.51209.nickpiggin@yahoo.com.au>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211453.26233.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX194FfgrD2U1sWsihk7KUL43emnHRsz7G48Nv+A
 aITM4kEx6wtRzdPiMwxVEdkvYB9rhWb+rGUwOYGPW29EzaAlG7
 tcDIlYUAkqq17NtdMpf2Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Nick Piggin wrote:
> On Thursday 21 August 2008 20:25, Carsten Otte wrote:
> > Jared Hulbert wrote:
> > > I'd like to get a first round of review on my AXFS filesystem.
> >
> > I like the general approach of it. It's much more flexible than the
> > ext2 extension I've done, and the possibility to select XIP vs.
> > compression per page is really really neat. I can imagine that people
> > will prefer this over the ext2 implementation on s390. It is unclear
> > to me how the "secondary block device" thing is supposed to work.
> > Could you elaborate a bit on that?
> 
> Agreed. I haven't had a good look through it yet, but at a glance it
> looks pretty neat. The VM side of things looks pretty reasonable
> (I fear XIP faulting might have another race or two, but that's a
> core mm issue rather than filesystem specific).

Yes, I also like the file system, I guess this is 2.6.28 material and
you should have it added to linux-next when you have addressed the
comments so far.

One thing that would be really nice is if you could add fake-write
support in the way that I proposed for cramfs a few months ago.
This would make axfs much more interesting for another set of
users, and keep cramfs a really simple example file system.

	Arnd <><
