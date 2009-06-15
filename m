Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZFOLF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZFOLF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZFOLFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:05:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64924 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZFOLFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:05:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 05/17] Blackfin: convert to generic checksum code
Date: Mon, 15 Jun 2009 13:04:15 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> <1244980878-2124-6-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244980878-2124-6-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906151304.16416.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18vnTQBVBjluhuQnKo/F4w5FduagKWjwQYiGJ8
 jTEtsL4zWh37xWcZ0Tv+cofb0wlqwBDpEeGUfSFmwWuMxFRKYq
 3OE2mdCvuBpIj4jys7bHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Mike Frysinger wrote:
> The Blackfin port only implemented an optimized version of the
> csum_tcpudp_nofold function, so convert everything else to the new
> generic code.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Have you tested this one well? I was as careful as possible with the
version I added, but it was basically only tested on microblaze, which
has a different endianess from blackfin. Some areas of the code may be
sensitive to this.

	Arnd <><
