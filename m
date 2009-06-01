Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZFAK22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZFAK22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbZFAK2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:28:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65084 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbZFAK2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:28:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Date: Mon, 1 Jun 2009 11:28:09 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <200905282104.55818.arnd@arndb.de> <20090601170847V.fujita.tomonori@lab.ntt.co.jp> <20090601082943.GA5550@flint.arm.linux.org.uk>
In-Reply-To: <20090601082943.GA5550@flint.arm.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906011128.10670.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+HHS5ZsF3SFJGhxe0dXNH8bsoTGXBWx9cZe5j
 fNX6tm8tret2kkLCMiEtqfdMpmTmjJh2cZNUn3zPN1VRFQqI5+
 W6WVUFPg2irKDCpnwStvv2cVsIjdTZm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009, Russell King wrote:
> On Mon, Jun 01, 2009 at 05:08:09PM +0900, FUJITA Tomonori wrote:
> > This adds a version of the dma-mapping API to asm-generic that can be
> > used by most architectures that only need a linear mapping.
> 
> It depends what is meant by "linear mapping".
> 
> If that's just a way of saying "all that needs to be done for the
> DMA streaming APIs is to flush the cache" then the vast majority of
> ARMs fall into that category.

Right. You can probably split out the arm dma-mapping.h implementation
into the dmabounce version and a version that falls back to my
asm-generic code.

One feature that the arm code currently has that I'm still missing is
highmem support, which seems to be relatively complex in arm
(three different implementations). Not sure how to best fit that in there.

	Arnd <><
