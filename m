Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbZBZAXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbZBZAXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZBZAXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:23:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:56761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZBZAXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:23:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [tip:core/header-fixes] compiler-gcc4: conditionalize #error on __KERNEL__
Date: Thu, 26 Feb 2009 01:21:18 +0100
User-Agent: KMail/1.9.9
References: <tip-442405f292c9f9e043afc2243a5b4128f2704c49@kernel.org>
In-Reply-To: <tip-442405f292c9f9e043afc2243a5b4128f2704c49@kernel.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902260121.18610.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18eNXIvHciWv2v1MEyxQ09JPOfkGgfwMLA6zmc
 ZreKi2hdOCF6FhhTduZIzdXledf/Nooc2OmwqRcHNwKlGHzU9E
 d/NEdi0jZiFQMdeza9KPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, H. Peter Anvin wrote:
> compiler-gcc4: conditionalize #error on __KERNEL__
> 
> Impact: Fix for exported headers
> 
> We only want to error out on specific gcc versions if we are actually
> building the kernel, so conditionalize the #if...#error on __KERNEL__.
> 
> Based on a patchset by Arnd Bergmann <arnd@arndb.de>.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

No kidding. It never occurred to me that this hunk from my patch was
any good. It just happened that I was cross compiling for powerpc
and only had a ppc64-gcc-4.1.0 installed on my laptop, so I commented
out that line with the intention of reverting that change after a
successful build...

Good catch!

	Arnd <><
