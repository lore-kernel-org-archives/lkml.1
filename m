Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbZCWSvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbZCWSvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZCWSvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:51:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58690 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZCWSvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:51:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 04/57] microblaze_v7: Open firmware files
Date: Mon, 23 Mar 2009 19:51:23 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       linuxppc-dev@ozlabs.org
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu> <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
In-Reply-To: <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903231951.23902.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+h+oH9Rxu4Bgy/euRFNX2x9tQhEQ/ZIpeX9Mh
 gQcQJGOQww4DoO5qX9RhgxLaJ6kPA3kCEo9096B5Rmi+f6/RZV
 KvJio98IVfexfUyuHiHng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, monstr@monstr.eu wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/include/asm/of_device.h   |   45 ++
>  arch/microblaze/include/asm/of_platform.h |   64 ++
>  arch/microblaze/include/asm/prom.h        |  313 ++++++++
>  arch/microblaze/kernel/of_device.c        |  115 +++
>  arch/microblaze/kernel/of_platform.c      |  201 +++++
>  arch/microblaze/kernel/prom.c             | 1147 +++++++++++++++++++++++++++++
>  arch/microblaze/kernel/prom_parse.c       | 1025 ++++++++++++++++++++++++++
>  7 files changed, 2910 insertions(+), 0 deletions(-)
>  create mode 100644 arch/microblaze/include/asm/of_device.h
>  create mode 100644 arch/microblaze/include/asm/of_platform.h
>  create mode 100644 arch/microblaze/include/asm/prom.h
>  create mode 100644 arch/microblaze/kernel/of_device.c
>  create mode 100644 arch/microblaze/kernel/of_platform.c
>  create mode 100644 arch/microblaze/kernel/prom.c
>  create mode 100644 arch/microblaze/kernel/prom_parse.c

Since these files are derived from the powerpc versions, what is the
plan on them? IIRC, you had them in a common directory in an earlier
version. Are you planning to merge them at some point in the future
or do you intend to maintain a fork?

	Arnd <><
