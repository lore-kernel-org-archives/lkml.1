Return-Path: <linux-kernel-owner+w=401wt.eu-S1763921AbZD3Ny6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763921AbZD3Ny6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762501AbZD3Nyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:54:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195AbZD3Nyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:54:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Date: Thu, 30 Apr 2009 15:53:46 +0200
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <200904271447.40984.arnd@arndb.de> <49F5A9A8.8010306@monstr.eu>
In-Reply-To: <49F5A9A8.8010306@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301553.47556.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ldyE4CZYnYWOYpvLcVxJSdqDusEKDmmAYWmU
 UutlCrxl2fxqx0GKVyV02ULF7f1VU11Ct8wIm9K3wDGvO4rRtw
 NZnWWLfNK1cqXDB+Yr4cQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Michal Simek wrote:
> Arnd Bergmann wrote:
> > On Monday 27 April 2009, Michal Simek wrote:
> >>> st_size represents an off_t in user space, which is signed.
> >>> Just over half the existing architectures use signed types
> >>> for st_size, but for this (like Sam's suggestion for __u64),
> >>> I don't think it matters either way.
> >> OK. Is it mean that your structure is perfect? If yes,
> >> I'll recompile toolchain and do some more tests. 
> > 
> > Please wait for my full patches, which I am about to
> > post. I hope to get to the stage where literally none
> > of the ABI is defined in your own header files but
> > it all gets into the generic parts. I hope to get this
> > out within a few hours.
> 
> OK.

Any success so far with the patches I posted? I guess you
need to apply just the first of the three microblaze patches
in the series first to see if that works, before changing
the signal handling and syscall table as well.

	Arnd <><
