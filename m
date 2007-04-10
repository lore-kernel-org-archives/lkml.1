Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbXDJOFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbXDJOFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXDJOFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:05:48 -0400
Received: from Apollo.christiedigital.com ([65.195.57.9]:59326 "EHLO
	CDSCYPEXG01.cds.int" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753804AbXDJOFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:05:47 -0400
X-Greylist: delayed 852 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2007 10:05:47 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Help Understanding Linux memory management
Date: Tue, 10 Apr 2007 09:51:48 -0400
Message-ID: <AD98412A5373CC4AA643D9C021922A541C4DC4@cdskitexg01.cds.int>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Help Understanding Linux memory management
Thread-Index: Acd7d2IpHNDXYpTLSHSqtgeR0ZyFVw==
From: "Mouawad, Tony" <Tony.Mouawad@christiedigital.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Apr 2007 13:51:49.0421 (UTC) FILETIME=[62EA85D0:01C77B77]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been a MS Windows based programmer for a very long time and was
recently tossed in an environment where I am developing embedded apps on
the m68k / Linux platform.  That makes me a Linux newbie.  I started
asking a few questions on various IRC channels and was directed to this
group.  So, I will start asking:

These are questions derived from observations on the MCF 5475 CPU
running Linux 2.6.10 built for the m68k platform.  Disk swapping is
disabled.

1) When physical memory runs low, the memory manager will try to use
memory currently allocated to the pagecache.  Is this true?

2) When vm.overcommit_memory = 2 (overcommit disabled), and memory runs
low, it appears that the memory manager does not try to use memory
currently allocated to pagecache.  Is this true?

3) Is it possible to disable the pagecache?

Cheers,
Tony



