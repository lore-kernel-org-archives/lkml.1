Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbZE0LIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbZE0LIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZE0LIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:08:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZE0LIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:08:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 08/29] microblaze_mmu_v2: Context handling - mmu_context.c/h
Date: Wed, 27 May 2009 12:08:06 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       microblaze-uclinux@itee.uq.edu.au, michal.simek@petalogix.com
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu> <1243406874-3917-8-git-send-email-monstr@monstr.eu> <1243406874-3917-9-git-send-email-monstr@monstr.eu>
In-Reply-To: <1243406874-3917-9-git-send-email-monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200905271208.07349.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX186M1cLEeoP82IK7WkDtG1c8U9m2gU8So9GQtk
 G/jbw3YJwLVWdErEtiQHAE+PabHnAax/XVsJbq5QsmRVXTsoYg
 jwTx71pve6o+7ABSrV7kL/gkH1hd10w
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 May 2009, Michal Simek wrote:
>  arch/microblaze/include/asm/mmu_context.h    |   26 +----
>  arch/microblaze/include/asm/mmu_context_mm.h |  140 ++++++++++++++++++++++++++
>  arch/microblaze/include/asm/mmu_context_no.h |   23 ++++
>  arch/microblaze/mm/mmu_context.c             |   70 +++++++++++++

It would be helpful to create the patches with 'git-format-patch -M -B',
in order to show renames as what they are, instead of a new file
and a removed file. For the git pull, this of course doesn't matter.

	Arnd <><
