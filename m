Return-Path: <linux-kernel-owner+w=401wt.eu-S1764142AbYDVPii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764142AbYDVPii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762119AbYDVPi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:38:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096AbYDVPi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:38:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Date: Tue, 22 Apr 2008 17:38:19 +0200
User-Agent: KMail/1.9.9
Cc: Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <20080422152122.GF19802@phobos.i.cabal.ca>
In-Reply-To: <20080422152122.GF19802@phobos.i.cabal.ca>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804221738.19635.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19XG/oviSbnfXcw9HaG2onwJqu9paORrDgctF9
 OUvoVcuHVXS5CG+gYfrkHEsKRtxqwreDJYUUI23pwi6jAJmFpw
 4BU0IaXX59RY56MxJRsuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008, Kyle McMartin wrote:
> 
> This should (imnsho, at least),
>         1 - Add a cond_syscall for sys_sysfs to sys_ni.c
>         2 - Use a CONFIG_EMBEDDED dependent option that defaults on,
>             possibly depend on BLACKFIN if you really want to.
> 
> Adding this junk to every arch header is, in my opinion, completely
> unacceptable just because blackfin wants to be different.

It's not that they want to be different, but rather that I (among others)
requested that they don't implement obsolete syscalls, so they removed it
from their syscall table.

	Arnd <><
