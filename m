Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZD0MsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZD0MsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZD0MsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:48:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbZD0MsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:48:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Date: Mon, 27 Apr 2009 14:47:40 +0200
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <200904271442.24870.arnd@arndb.de> <49F5A8AB.4040707@monstr.eu>
In-Reply-To: <49F5A8AB.4040707@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271447.40984.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18S1a2vMyAq1Nv4MgXJbpDbbOWsxriEmD6dEo3
 CR1pLp8b+AlzfXFxpKCh4OnLAQF0VBTA4nX6JRJhq5unU6eMY0
 X4W4J0rnxMAFjhjrc/18A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Michal Simek wrote:
> > st_size represents an off_t in user space, which is signed.
> > Just over half the existing architectures use signed types
> > for st_size, but for this (like Sam's suggestion for __u64),
> > I don't think it matters either way.
> 
> OK. Is it mean that your structure is perfect? If yes,
> I'll recompile toolchain and do some more tests. 

Please wait for my full patches, which I am about to
post. I hope to get to the stage where literally none
of the ABI is defined in your own header files but
it all gets into the generic parts. I hope to get this
out within a few hours.

	Arnd <><
