Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYE2HK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYE2HK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 03:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYE2HKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 03:10:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56074 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbYE2HKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 03:10:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: benh@kernel.crashing.org
Subject: Re: MMIO and gcc re-ordering issue
Date: Thu, 29 May 2008 09:10:06 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
References: <1211852026.3286.36.camel@pasglop> <alpine.LFD.1.10.0805271451100.2958@woody.linux-foundation.org> <1211926779.3286.104.camel@pasglop>
In-Reply-To: <1211926779.3286.104.camel@pasglop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805290910.07207.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18ZB+ffE2+GuY6hAwJ+Y4xbjsvL6YP/A/ACoOm
 ByU/kElgs4Lvyrzo/pdB9SkyGPr515X0QuzCKcsH5Q3t1+9lj5
 o8sqNvedICqUdQMnzLJvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2008, Benjamin Herrenschmidt wrote:
> On Tue, 2008-05-27 at 14:55 -0700, Linus Torvalds wrote:
> > 
> > On Wed, 28 May 2008, Benjamin Herrenschmidt wrote:
> > > 
> > > A problem with __raw_ though is that they -also- don't do byteswap,
> > 
> > Well, that's why there is __readl() and __raw_readl(), no?
> 
> As I replied to somebody else, __readl() is news to me :-) we dont' have
> those on powerpc.
> 

It's not exactly a well-established interface. Only five architectures
define these functions, and there is not a single user in the kernel
source outside of these architecture's io.h files.

	Arnd <><
