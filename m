Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbZDNNyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbZDNNyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbZDNNxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:53:49 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:49974 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZDNNxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:53:48 -0400
Message-Id: <20090414135327.576111185@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 15:53:27 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 00/14] s390 patches for 2.6.30-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
the usual bug fixes for an -rc release and some cpu time accouting
improvements. Nothing major, the shortlog:

Christian Ehrhardt (1):
      [S390] s390: move machine flags to lowcore

Cornelia Huck (1):
      [S390] dasd: Use the new async framework for autoonlining.

Gerald Schaefer (1):
      [S390] appldata: Use new mod_virt_timer_periodic() function.

Heiko Carstens (3):
      [S390] wire up preadv/pwritev system calls
      [S390] call nmi_enter/nmi_exit on machine checks
      [S390] smp: fix cpu_possible_map initialization

Jan Glauber (2):
      [S390] extend virtual timer interface by mod_virt_timer_periodic
      [S390] qdio: remove dead timeout handler

Martin Schwidefsky (5):
      [S390] stp synchronization retry timer
      [S390] fix idle time accounting
      [S390] cpu hotplug and accounting values
      [S390] add read_persistent_clock
      [S390] boot cputime accounting

Stefan Weinhuber (1):
      [S390] dasd: fix idaw boundary checking for track based ccw

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

