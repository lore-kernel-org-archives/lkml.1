Return-Path: <linux-kernel-owner+w=401wt.eu-S1763718AbZEHPro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763718AbZEHPro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758350AbZEHPqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:46:36 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:60210 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763539AbZEHPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:46:34 -0400
Message-Id: <20090508154407.956216094@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 08 May 2009 17:44:08 +0200
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
during test cases. Patch base is 2.6.30-rc4.

Changes since last version:
* moved compiler version assertion to include/linux/compiler-gcc3.h
* moved all module-specific code under CONFIG_MODULES
* added symbolic names for gcda file record numbers
* split seq_write_gcov_int() into two functions
* coding style changes:
  * fixed multi-line comments
  * added braces for multi-line blocks
  * improved rc and error label usage
  * made local variable initialization consistent
  * added initialization indentation
  * improved readability by using local variables

Patch overview:
[PATCH 1/4] kernel: constructor support
[PATCH 2/4] seq_file: add function to write binary data
[PATCH 3/4] gcov: add gcov profiling infrastructure
[PATCH 4/4] gcov: enable GCOV_PROFILE_ALL for x86_64

For more information see Documentation/gcov.txt and the previous post:
http://marc.info/?l=linux-kernel&m=123565658224661

