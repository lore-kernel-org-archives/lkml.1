Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbYCCGWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbYCCGWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 01:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYCCGWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 01:22:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50147 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYCCGWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 01:22:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: SCHED_IDLE documentation
Date: Mon, 3 Mar 2008 07:21:52 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: cbe-oss-dev@ozlabs.org, Jeremy Kerr <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Michael Kerrisk <mtk.manpages@googlemail.com>
References: <1203376368.275756.252634247263.1.gpush@pokey> <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de>
In-Reply-To: <20080303051719.GA26102@lst.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803030721.52869.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+u/fg6xl4Fu1NzXBPaDugoj5x+JYc+h0pf4CT
 32OaExwIiochj3UCG/G6szcDwwYULHkbX/AnLFnv9tem98HntH
 rA8NglDzI/evudYHSv+iA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008, Christoph Hellwig wrote:
> On Mon, Mar 03, 2008 at 06:12:27AM +0100, Arnd Bergmann wrote:
> > > I'm okay with the algorithm, but please don't use policy == SCHED_IDLE
> > > as the flag for it. ?SCHED_IDLE is a user-visible and user-settable
> > > scheduler class and we shouldn't overload this. 
> > 
> > Ah, didn't know that. Is that a fairly recent interface in Linux? I can't
> > find any reference to it in the sched_setscheduler man page, though the
> > mail archives have numerous discussions about the semantics throughout
> > the last 10 years.
> 
> It went in with the CFS scheduler and is indeed as far as I can tell
> totally undocumented (sigh..)

So was there no documentation written for it, or does the new man page
just need to make it into distro releases?

If we don't have any man page, what is the actual definition of SCHED_IDLE
anyway?

	Arnd <><
