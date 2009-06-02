Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbZFBLpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbZFBLpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760702AbZFBLoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:44:37 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:51661 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416AbZFBLob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:44:31 -0400
Message-Id: <20090602114359.129247921@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 02 Jun 2009 13:43:59 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Huang Ying <ying.huang@intel.com>, Li Wei <W.Li@Sun.COM>,
       Michael Ellerman <michaele@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>
Subject: [PATCH 0/4] gcov kernel support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements support for performing kernel code coverage
measurements based on gcc's gcov mechanism. It can be used to improve
kernel code quality by identifying code parts which are not exercised
during test cases. Patch base is 2.6.30-rc7.

Changes since last version:
* removed __gcov_execve (assuming no kernel function will be called
  execve)

Patch overview:
[PATCH 1/4] kernel: constructor support
[PATCH 2/4] seq_file: add function to write binary data
[PATCH 3/4] gcov: add gcov profiling infrastructure
[PATCH 4/4] gcov: enable GCOV_PROFILE_ALL for x86_64

For more information see Documentation/gcov.txt and the previous post:
http://marc.info/?l=linux-kernel&m=123565658224661

