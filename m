Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbZEANaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbZEANaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761834AbZEAN3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:29:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761823AbZEAN3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:29:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 04/27] asm-generic: add legacy I/O header files
Date: Fri, 1 May 2009 15:29:04 +0200
User-Agent: KMail/1.9.9
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
       linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <20090501123728.GC27799@flint.arm.linux.org.uk> <20090501140904.69f44406@lxorguk.ukuu.org.uk>
In-Reply-To: <20090501140904.69f44406@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905011529.04774.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/EU/7gEO5O0ncrZYsnAvm84bbJDoUxfOQaB3Z
 eT3nFRZuvx/IejzZrwm8jaN/gAts+/N4iAC1pUlGiQ7yAem6MO
 zVK+nj4a6aOdUoSKBMY2A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009, Alan Cox wrote:
> Joining in late but its not at all highly PC specific. The same frequency
> is used for a whole pile of setups (Alpha etc). It's not well named but
> there are good sound reasons the PC chose 1193182 and while those reasons
> have long lapsed its a good frequency for other reasons nowdays.
> 
> The clock isn't for the PIC either - its for the PIT (although its used
> to clock various other things).
> 
> We actually have a define of PIT_TICK_RATE internal to the x86 port for
> those x86 cases that can use it.

How about this comment then:

/*
 * CLOCK_TICK_RATE is traditionally the base frequency using the PC-style
 * i8253 "PIT" timer. Architecture independent device drivers should not
 * rely on this value.
 * Any architecture that either has a real PC-style PIT, or does not have a
 * fixed timer interval at all and just needs to provide some value here
 * should just fall back to this default.
 */

	Arnd <><
