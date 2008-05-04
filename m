Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbYEDWpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbYEDWpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 18:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYEDWpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 18:45:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61713 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYEDWpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 18:45:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 52/56] microblaze_v2: pci headers
Date: Mon, 5 May 2008 00:45:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <affa82887bee64b05420fdd5f723cca920acad90.1209897267.git.monstr@monstr.eu> <c709de3e3767d1be8b23ce73255389c525737c36.1209897267.git.monstr@monstr.eu>
In-Reply-To: <c709de3e3767d1be8b23ce73255389c525737c36.1209897267.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805050045.29614.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX191dfJjciR2gffUvQcmEn2c/QZ3jjUWa40CLa5
 T9CHquKOus1Vit9mhJLzzq5taQHz03rTTyckcexZu/u1m2i53c
 6UuHwyxnNpEmhv0eUNE4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, monstr@seznam.cz wrote:
> +
> +#ifdef __KERNEL__
> +#include <asm/io.h>
> +#endif

You don't export asm/pci.h to userspace, so the #ifdef __KERNEL__ is
not needed.

	Arnd <><
