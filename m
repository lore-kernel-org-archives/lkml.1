Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbZGALmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbZGALmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZGALm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:42:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64904 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbZGALm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:42:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [microblaze-uclinux] [PATCH 03/11] microblaze: fall back on generic header files for the ABI
Date: Wed, 1 Jul 2009 13:42:26 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
References: <cover.1245345894.git.arnd@arndb.de> <7a92dd639b7887bc972118d16a5fda6093200b96.1245347640.git.arnd@arndb.de> <4A4B49D0.2090101@monstr.eu>
In-Reply-To: <4A4B49D0.2090101@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907011342.26669.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19wKeWWbl/YYkF4YG5b7pWDKgq1KY5LmIY5k0n
 3IdzrqxV90c6eqEjMDPdD5b72MVPSMOOK1BFm3BnuzBddT4mEF
 /ncPsw3+bwX1boNRrtY4A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009, Michal Simek wrote:
> Added to next branch for test.
> 
> I had to do one change.
> Microblaze needs __kernel_mode_t as short.

Can you explain why that is needed? Should I change the default in the generic file?

> + I removed __kernel_size_t and I'll recompile toolchain
> for removing warning messages

Ah, good.

	Arnd <><
