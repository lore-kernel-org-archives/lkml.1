Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZELPj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZELPj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZELPjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:39:17 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:38059 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZELPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:39:14 -0400
Message-Id: <20090512153851.939166562@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 12 May 2009 17:38:51 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>
Subject: [PATCH 0/4] gcov kernel support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements support for performing kernel code coverage
measurements based on gcc's gcov mechanism. It can be used to improve
kernel code quality by identifying code parts which are not exercised
during test cases. Patch base is 2.6.30-rc5.

Changes since last version:
* updated to 2.6.30-rc5
* moved __ctors_start and __ctors_end declaration to
  include/asm-generic/sections.h

Patch overview:
[PATCH 1/4] kernel: constructor support
[PATCH 2/4] seq_file: add function to write binary data
[PATCH 3/4] gcov: add gcov profiling infrastructure
[PATCH 4/4] gcov: enable GCOV_PROFILE_ALL for x86_64

For more information see Documentation/gcov.txt and the previous post:
http://marc.info/?l=linux-kernel&m=123565658224661

