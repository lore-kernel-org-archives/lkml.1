Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbYFQWCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbYFQWCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbYFQWCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:02:05 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:14514 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbYFQWCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:02:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=j89AbpWnZz6ziioyDnvPcJ2cKmM/YjYm9gI58C+DQMJ4cX2/AnBzxHqi+86t2uGJut
         mtuv19/BetNJlXRos9Nbv1nzpP7XBBcxkIO4sKfj6/Qo8R59U4a3T9nBNmaQLkmbFFuM
         H157lLF+outiJtkaafkrNkeusnOAC7ZwoEiqQ=
To: linux-kernel@vger.kernel.org
Subject: [patch 00/19] perfmon2 minimal v2:  introduction
From: eranian@googlemail.com
Date: Tue, 17 Jun 2008 15:02:01 -0700 (PDT)
Message-ID: <48583459.0917400a.2d99.ffff9b6a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches implement a minimal perfmon2 subsystem which provides
access to the hardware performance counters of modern processors.

This series supports ONLY per-thread counting of PMU events (no sampling) for
AMD64 and Intel Core processors in both 32 and 64 bit modes.

This is version 2 of the series following the feedback from LKML. The series
is against 2.6.26-rc6. Compared to previous version, this new series
addresses the comments I received from Aran, Greg KH and others:

    - some small patches were integrated with other bigger patches which
      they closely related to.

    - sysfs code has been largely simplified

Please review.

Signed-off-by: Stephane Eranian <eranian@gmail.com>

-- 

