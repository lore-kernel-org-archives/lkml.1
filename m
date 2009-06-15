Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZFOLnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZFOLnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZFOLnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:43:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55970 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZFOLnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:43:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 00/17] Blackfin arch conversion to asm-generic
Date: Mon, 15 Jun 2009 13:42:22 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906151342.22872.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/qN/ZrIvkXPp7JcNudG+SDfOQ4l3EZ4Jx83nN
 P18nUmOvofy9oXz07xScQsMpPnpdKeOSlURrf62JUYvUcKd8mh
 TKhhY7JBocfcX/dcg8BbfwqR5krNTsl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Mike Frysinger wrote:
> 
> With the new asm-generic code in place, we can convert the Blackfin arch
> over to it.  This in turn fixes a few outdated headers and rather than
> manually update them, just drop our version in favor of the asm-generic
> one.  I've tried to group the changes somewhat logically so that if some
> conversion did go bad, it'll be easier to narrow things down with bisect
> rather than one large changeset.
...
>  65 files changed, 141 insertions(+), 2437 deletions(-)
>  delete mode 100644 arch/blackfin/lib/checksum.c

Very nice!

I've reviewed your patches based on my experience of working on the
asm-generic files and it all looks good to me, except for the dma-mapping.h,
for which I've sent you a replacement patch.

	Arnd <><
