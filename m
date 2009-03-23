Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbZCWTff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbZCWTff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZCWTfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:35:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbZCWTfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:35:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 07/57] microblaze_v7: Signal support
Date: Mon, 23 Mar 2009 20:35:14 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu> <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
In-Reply-To: <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903232035.15100.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/GmjHrsrcqVqJOyvpa9NSorsI7Ubjjrgk9SZN
 YiAY1zzIyuNImkOGFWkKoe/D/LQtYgeICloSOhK32W7FfzpARe
 f4kBb+i3SB1/cZsPYeD/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, monstr@monstr.eu wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/include/asm/signal.h |  165 +++++++++++
>  arch/microblaze/kernel/signal.c      |  536 ++++++++++++++++++++++++++++++++++
>  2 files changed, 701 insertions(+), 0 deletions(-)
>  create mode 100644 arch/microblaze/include/asm/signal.h
>  create mode 100644 arch/microblaze/kernel/signal.c

> From: Michal Simek <monstr@monstr.eu>
>
>
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/include/asm/ipc.h       |    1 +
>  arch/microblaze/include/asm/ipcbuf.h    |   36 +++++
>  arch/microblaze/kernel/sys_microblaze.c |  226 +++++++++++++++++++++++++++++++
>  3 files changed, 263 insertions(+), 0 deletions(-)
>  create mode 100644 arch/microblaze/include/asm/ipc.h
>  create mode 100644 arch/microblaze/include/asm/ipcbuf.h
>  create mode 100644 arch/microblaze/kernel/sys_microblaze.c

I don't quite remember what the outcome of this discussion was the last
time, but what is your plan for the deprecated syscalls like the
legacy syscalls you add here?

Have you tried changing uClibc and/or glibc so you don't need them?
Are you planning to remove them soon once they are not needed any
more?

What about the syscalls that are not needed but you just get from
common code (e.g. oldumount, time, old_readdir, ...)?

	Arnd <><
