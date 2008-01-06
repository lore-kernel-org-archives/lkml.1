Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYAFPbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYAFPbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYAFPbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:31:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbYAFPbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:31:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] x86: ioport_{32|64}.c unification
Date: Sun, 6 Jan 2008 16:30:09 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Miguel =?iso-8859-15?q?Bot=F3n?= <mboton.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de
References: <200801060059.48333.mboton@gmail.com> <200801060220.45669.mboton@gmail.com> <26046.1199598953@turing-police.cc.vt.edu>
In-Reply-To: <26046.1199598953@turing-police.cc.vt.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801061630.10265.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19XJrpWYYdnSRXlzNqCjSIXwB/lt5n7rzbQIwQ
 Zt7raoJz8rwegEZSf1mXoD2wEqxyg+J0YYx3/RhziL3wPFzy8Y
 dx2jY71+defhRtuBBlRPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 January 2008, Valdis.Kletnieks@vt.edu wrote:

> You'll still need some ad-croc ifdef-ery at the call site to make it use
> the correct prototype (unless you can come up with some clever way of making
> the two use the same prototype, possibly by passing a dummy argument on
> some architectures...

The call site is the sys_call_table, and user space already has different
calling conventions here, which is the whole reason for this mess.

	Arnd <><
