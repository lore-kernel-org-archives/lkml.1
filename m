Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbZGCMdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbZGCMdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZGCMdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:33:00 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42833 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbZGCMc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=veWTqouWY7sNxVCgkq2PTblfbLzyDHwioO9Uv2zTftsm1hhSLcHOUtMFRubMvo2tKU
         d1Pw+YMj5YMnRIAZqrwF5Ck54hYN/QZGrCZ+xJfJFJs8eOsiyfkqVsBYccX2ifLJMa68
         bHuXVU9mIIs6LgQmhTU1qpF7VduWus7msMrKc=
MIME-Version: 1.0
Date: Fri, 3 Jul 2009 15:33:01 +0300
Message-ID: <5d96567b0907030533r5db79f9bi709f50d270706867@mail.gmail.com>
Subject: RE: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling 
	policy flag, Second try
From: Raz <raziebe@gmail.com>
To: mzxreary@0pointer.de
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart  Hello
I had the same problem several years ago, but in the servers arena.
in order to solve it  I partitioned the solution to two:
1. UNI processors machines
2. SMP processors machines

In UNI processor I created a RT kthread that polls over RTC device.
The observed jitter was 400us.
in SMP processors machine we created a new type of scheduling , called offline.
what i did it to offload a processor and assign it task. jitter is
250us under heavy load. solution is open source and can be found at :
http://sos-linux.svn.sourceforge.net/viewvc/sos-linux/offsched/Documentation/

Raz
