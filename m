Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbXLaQK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbXLaQK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbXLaQKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:10:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54270 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXLaQKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:10:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [2.6.24 patch] Fix Cell OProfile support
Date: Mon, 31 Dec 2007 17:10:06 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       linux-kernel@vger.kernel.org, paulus@samba.org,
       oprofile-list@lists.sourceforge.net
References: <20071228185649.GC4738@stusta.de> <20071229160921.GB12262@Krystal>
In-Reply-To: <20071229160921.GB12262@Krystal>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712311710.08869.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+v8QHyl8cnpzetR1kvhJa1Q3bSvLpIsln6H9k
 +MrqtxM0A6Ro9CGepMsM+dsD7lEl+Zn+61FtRP6xfU/lvNDML1
 4/A3+uXmBowguwdPV5ctA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 December 2007, Mathieu Desnoyers wrote:
> This patch restores the Cell OProfile support that was killed by
> commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> 
> It puts it in arch/powerpc/Kconfig. Since I don't see any good reason to leave
> this as a supplementary user-selectable option, it is now automatically enabled
> whenever SPU_FS and OPROFILE are enabled.

This one has already been superceded by the fix in 
aed3a8c9bb1a8623a618232087c5ff62718e3b9a, which made CONFIG_OPROFILE_CELL an
automatically selected option, from arch/powerpc/platforms/cell/Kconfig.

	Arnd <><
