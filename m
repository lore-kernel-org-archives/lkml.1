Return-Path: <linux-kernel-owner+w=401wt.eu-S1763413AbZFNUfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763413AbZFNUfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZFNUfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:35:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56754 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763969AbZFNUfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:35:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 3/4] asm-generic: uaccess: fix up local access_ok() usage
Date: Sun, 14 Jun 2009 22:35:03 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1244959204-11269-1-git-send-email-vapier@gentoo.org> <1244959204-11269-3-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244959204-11269-3-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906142235.03440.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/pmVQ2z5QkDndvncp0xp4H+japDf8d2QsJoqr
 sFbrZkCHmClAXhDUfJg5N4goF9sY1sN7o09mPZPA4GSLmt+v8S
 99faV7AS/hvdeqh8vMDqTL22GJw/VdV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Mike Frysinger wrote:
> There's no reason that I can see to use the short __access_ok() form
> directly when the access_ok() is clearer in intent and for most people,
> expands to the same C code (i.e. always specify the first field -- access
> type).  Not all no-mmu systems lack memory protection, so the read/write
> could feasibly be checked.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied, thanks.

	Arnd <><
