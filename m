Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbZFQHmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbZFQHmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZFQHl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:41:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZFQHl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:41:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Ungerer <gerg@snapgear.com>
Subject: Re: [PATCH] m68k: merge the non-mmu and mmu versions of hardirq.h
Date: Wed, 17 Jun 2009 09:41:43 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gerg@uclinux.org, linux-m68k@vger.kernel.org
References: <200906170710.n5H7AxxV009015@localhost.localdomain>
In-Reply-To: <200906170710.n5H7AxxV009015@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906170941.44383.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18yy5IyAqqzUt81FuGYJb13WyZMJZ3cU7xe9kR
 zuXZ++QP8kut8dI8+gduKttwFmC4KZ8ZrEN6Ids4AfqvIfHfIu
 WUKZWaqQIiYpswBhDHuVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 June 2009, Greg Ungerer wrote:
> [PATCH] m68k: merge the non-mmu and mmu versions of hardirq.h
> 
> There is nothing different required between the non-mmu and mmu
> versions of hardirq.h, so merge them back into a single file.
> 
> Signed-off-by: Greg Ungerer <gerg@uclinux.org>

AFAICT this file is also the same in the new asm-generic version, so you
could fall back to that directly.

	Arnd <><
