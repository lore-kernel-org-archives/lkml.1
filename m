Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZHNLo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZHNLo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbZHNLoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:44:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:61443 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbZHNLox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:44:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Schnell <mschnell@lumino.de>
Subject: Re: implementing Futex
Date: Fri, 14 Aug 2009 13:44:50 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de> <4A85327D.2040003@lumino.de>
In-Reply-To: <4A85327D.2040003@lumino.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908141344.50639.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+9gWbAurF2Vl4/HDAw4LcQsXbORfxuug4QVCk
 NBLkY7q0DSp3eVFZm9we48lxH+KcebCoHKFbp5QpU9V4ddQWXx
 r1QW+UJhfPggMXLDLU76Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Michael Schnell wrote:
> Does that mean that both in fact do run in the same mode (I suppose
> Kernel Mode and thus the CPU's "System Mode" rather than the CPU's "User
> Mode".

yes

> With that - and supposing that as of Kernel 2.6.31 the sh code I see in
> Kernel 2.6.30 is used in /asm/generic, I would be able to just use the
> "generic" case for "implementing" a working Futex syscall for the NIOS).

Well, I haven't put that code into asm-generic/futex.h yet and it's
too late for 2.6.31, but it should get there eventually, if one of us
four submits a tested patch ;-).

In the meantime, I suggest you use a plain copy of the sh version.

	Arnd <><
