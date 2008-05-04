Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYEDTnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYEDTnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYEDTmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:42:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:52883 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbYEDTmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:42:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 1/2] OF: Fix coding style violation in of_device.c and of_platform.c
Date: Sun, 4 May 2008 21:42:45 +0200
User-Agent: KMail/1.9.9
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <monstr@seznam.cz> <200805032304.58709.arnd@arndb.de> <481D71D3.7060703@seznam.cz>
In-Reply-To: <481D71D3.7060703@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805042142.45872.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/FsWmwOj/jR3J72zcmaPWwcX/12MEkJ5FT+L3
 1fpu8Iq8F1dsrO5Yfn5loX0KbG5tpflwx0N0URCczmqA5IwTGq
 vkqMNe7EeOChKw3bdfNfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, Michal Simek wrote:
> this is question to powerpc guys not to me. I haven't tried to compiled but I
> think dcr.h is important header for powerpc.
> I only fixed problem for Microblaze because we don't have these headers.

A google search on "microblaze DCR" shows a number of results, leading me to
the conclusion that microblaze actually does have DCR registers. In that
case, the best option should be to just implement a dcr.h based on 
asm-powerpc/dcr-native.h.

	Arnd <><
