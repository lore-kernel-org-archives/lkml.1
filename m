Return-Path: <linux-kernel-owner+w=401wt.eu-S1761159AbZEGMqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761159AbZEGMqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZEGMqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:46:09 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:43382 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbZEGMqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:46:08 -0400
Message-Id: <20090507124556.041286732@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 07 May 2009 14:45:56 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>
Subject: [PATCH 0/4] gcov kernel support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements support for performing kernel code coverage
measurements based on gcc's gcov mechanism. It can be used to improve
kernel code quality by identifying code parts which are not exercised
during test cases. Patch base is 2.6.30-rc4.

Changes since last version:
* fix return code of gcov_seq_show

Patch overview:
[PATCH 1/4] kernel: constructor support
[PATCH 2/4] seq_file: add function to write binary data
[PATCH 3/4] gcov: add gcov profiling infrastructure
[PATCH 4/4] gcov: enable GCOV_PROFILE_ALL for x86_64

For more information see Documentation/gcov.txt and the previous post:
http://marc.info/?l=linux-kernel&m=123565658224661

