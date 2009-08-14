Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZHNNdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZHNNdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbZHNNdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:33:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbZHNNdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:33:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Schnell <mschnell@lumino.de>
Subject: Re: implementing Futex
Date: Fri, 14 Aug 2009 15:33:16 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jakub Jelinek <jakub@redhat.com>, Thomas Chou <thomas@wytron.com.tw>
References: <4A842B32.5030401@lumino.de> <200908141438.01392.arnd@arndb.de> <4A855EE5.9010105@lumino.de>
In-Reply-To: <4A855EE5.9010105@lumino.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908141533.16714.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+ORDwk1rfp82/v5GoSwRZxXL+iQdy8KLIKKrJ
 lRvAMtcgOKmtD8YLs/jnplL7F7sFAubBMVoWmE+4T64NFgUUNA
 /bdyhxxnOVJ+CdXhy7OuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Michael Schnell wrote:
> Arnd Bergmann wrote:
> > The man page says that the last parameter is ignored for op=FUTEX_WAKE,
> > which is correct. The code that you were looking at however is for
> > of=FUTEX_WAKE_OP, which is not documented as of manpages-3.22.
> > 
> > It was added by Jakub back in 2005, but if he wrote a documentation
> > for it, it never went into the man pages package. On a similar
> > note, Ingo also added other futex operations that are not documented
> > yet.
> > 
> 
> Thus in any documented software, the quite complex stuff in
> "futex_atomic_op_inuser", which is provided in several different
> "futex.h" files for all those architectures never is used ?

No, my point was that futex_atomic_op_inuser is indeed used
correctly, it's just not documented.
See http://lwn.net/Articles/148830/ for the initial posting

> Is there any viable use for this ?

glibc heavily uses it for the pthreads implementation.
 
> Would it not be appropriate either to do a documentation or to remove it ?

Adding documentation, yes.

	Arnd <><
