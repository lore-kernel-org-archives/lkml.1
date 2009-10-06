Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZJFEep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZJFEep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 00:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZJFEeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 00:34:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35382 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZJFEen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 00:34:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for October 5 (android)
Cc: kosaki.motohiro@jp.fujitsu.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091005162129.08749093.randy.dunlap@oracle.com>
References: <20091005190324.7013a4bb.sfr@canb.auug.org.au> <20091005162129.08749093.randy.dunlap@oracle.com>
Message-Id: <20091006133202.5FAD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Oct 2009 13:34:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


> > Hi all,
> > 
> > Changes since 20091002:
> 
> drivers/staging/android/lowmemorykiller.c: In function 'lowmem_shrink':
> drivers/staging/android/lowmemorykiller.c:111: error: 'struct mm_struct' has no member named 'oom_adj'

I've already fixed it and andrew pick it up to -mm at 11/Sep.


> 
> config := config-and1
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> drivers/staging/android/logger.c:165: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> drivers/staging/android/logger.c:165: error: (Each undeclared identifier is reported only once
> drivers/staging/android/logger.c:165: error: for each function it appears in.)
> drivers/staging/android/logger.c:178: error: implicit declaration of function 'signal_pending'
> drivers/staging/android/logger.c:183: error: implicit declaration of function 'schedule'
> drivers/staging/android/logger.c: In function 'logger_aio_write':
> drivers/staging/android/logger.c:325: error: dereferencing pointer to incomplete type
> drivers/staging/android/logger.c:333: error: dereferencing pointer to incomplete type
> drivers/staging/android/logger.c:334: error: dereferencing pointer to incomplete type
> drivers/staging/android/logger.c:337: error: dereferencing pointer to incomplete type
> drivers/staging/android/logger.c:360: error: dereferencing pointer to incomplete type
> drivers/staging/android/logger.c:363: error: dereferencing pointer to incomplete type
> drivers/staging/android/logger.c:370: error: increment of pointer to unknown structure
> drivers/staging/android/logger.c:370: error: arithmetic on pointer to an incomplete type
> drivers/staging/android/logger.c:377: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> make[4]: *** [drivers/staging/android/logger.o] Error 1
> 
> config := config-and2
> 
> 
> ---
> ~Randy



