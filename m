Return-Path: <linux-kernel-owner+w=401wt.eu-S1030214AbXBZNI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030214AbXBZNI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030216AbXBZNI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:08:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:42678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030214AbXBZNIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:08:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,220,1170662400"; 
   d="scan'208"; a="201341536:sNHT18937303"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Cfq  first request patch changes IO performance
Date: Mon, 26 Feb 2007 16:08:43 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC872B21@mssmsx411>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Cfq  first request patch changes IO performance
Thread-Index: AcdZpz288AMyxTftTlKlTjsLpjAxSQ==
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Feb 2007 13:08:54.0336 (UTC) FILETIME=[44487C00:01C759A7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "cfq-iosched: defer slice activation to first request being
active"
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=c
ommitdiff;h=44f7c16065c83060cbb9dd9b367141682a6e2b8e;hp=99f9628aba4d8fb3
b8d955c9efded0d0a1995fad

Sysbench fileio (random read/write mix)	-15%
Tiobench sequential write		-3%
Tiobench random write 			-5%
Iozone record re-write			-21%
Iozone mmap sequential read 		-20%
Iozone mmap random write		+45%
Aio-stress direct sequential read		+29%
For other 3 tiobench, 7 aiostress and 13 iozone tests the result changes
are less than variation.

Considered patch does not impact on performance if all threads have
equal IO activity (tiobench).
If single thread has IO activity the performance becomes unstable and is
decreased mainly.

Leonid
