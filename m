Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbZFALmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbZFALmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 07:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbZFALm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 07:42:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbZFALm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:42:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Date: Mon, 1 Jun 2009 12:42:21 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20090601082943.GA5550@flint.arm.linux.org.uk> <200906011141.33463.arnd@arndb.de> <20090601105851.GB25391@flint.arm.linux.org.uk>
In-Reply-To: <20090601105851.GB25391@flint.arm.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906011242.22026.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18GK8WP2LsHTxx+zdHMR6N9Fz2qwwtx9F9gdgQ
 xXms3zO65ToeXjLy1084xbhCqTJnoucvqsultkTqyebYaYpaNl
 AOf8KCYLgcTKLMNPX2upWlK9Bs00GTb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009, Russell King wrote:

> I didn't say "for all architectures".  I said that the end conditions
> need to be the same no matter how DMA is done.
> 
> And yes, it does matter with some cache types.  VIPT aliasing caches
> and VIVT caches both need to ensure that condition is met, otherwise
> userspace doesn't see the data.

Ok, thanks for the explanation.

> While we can hand-wave and say "some other part of the code should
> handle this" I've had that disucssion several times, and that's where
> this requirement eventually was stated.  And, really, I'm not going
> to re-discuss it yet again - I really don't have time or motivation
> at present to be involved in yet another hand-waving egotistical
> debate over it.

I was not trying to start a debate over this, just being curious.

	Arnd <><
