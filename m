Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbZGIM3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbZGIM3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757947AbZGIM3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:29:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64230 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbZGIM3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:29:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/5] sparc: use asm-generic/dma-mapping-common.h
Date: Thu, 9 Jul 2009 14:29:23 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.95; x86_64; ; )
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, reif@earthlink.net
References: <1246860820-20629-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20090706.181131.92078657.davem@davemloft.net> <20090709185505X.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090709185505X.fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907091429.24100.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+smCh4UEBntR4e214+Nv2cNN9pj60nin51z3b
 Rf2D0DGeKjfGxWjLgHzVdASyHT1hPkpK4wAva9LodaOr/6Y9M2
 E+jF8Knoc8HUu0C3Ted5JBcg4pVCHtE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 July 2009, FUJITA Tomonori wrote:
> The logic to move flush_write_buffers() from dma-mapping-common.h to
> arch/x86/kernel/pci-nommu.c makes sense and it doesn't break anything.
> However, I'd like to see the confirmation from a person who added
> flush_write_buffers() long ago. I thought that we might overlook
> something subtle.

I've tried to find out where it comes from, but unfortunately it's
from prehistoric times (Linux-2.4.14.2), the commit is in 

http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=a8a2069f432c5597bdf9c83ab3045b9ef32ab5e3

None of the comments in that commit seem to refer to
the actual change.

	Arnd <><
