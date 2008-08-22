Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbYHVMmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbYHVMmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbYHVMmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:42:01 -0400
Received: from mx.bridgeco.net ([213.173.191.47]:2236 "EHLO mx.bridgeco.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbYHVMmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:42:00 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2008 08:42:00 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Behaviour of the VM on a embedded linux
Date: Fri, 22 Aug 2008 14:31:43 +0200
Message-ID: <83116F0A4FF67A4F97BA0B6E408C48E30289D8F0@zuerich.BC-Int.NET>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Behaviour of the VM on a embedded linux
Thread-Index: AckEUwkpctPrcquDRZG0vmFuOQTyxA==
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Aug 2008 12:31:22.0137 (UTC) FILETIME=[FC2C7090:01C90452]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

I'm trying to figure out whats going on an embedded system I have to deal with. It's running a 2.6.24.7 kernel on 32 MBytes of RAM.
There is no swapping. There are some daemons and shells running and - a big monolithic c++ application.

The application runs a lot of pthreads on different real time priority levels. It looks like the application consumes  a huge
ammount of real memory in contrast to the assumption, that large code size is no problem due to paging out pages with unused code.

I'm not so familiar with the VM internas of the Linux kernel - I only have some general ideas about systems using MMUs. So my
assumption was, that even if a application consists of a lot of code, almost all memory pages containing executable code can be
paged out in favour of pages which are needed to store data (stacks, heap, slab). I tried to figuring this out through reading in
different books like "understanding the linux kernel" but those parts I was not able to catch anywhere.

Now there is the idea, that pages which contain code of pthreads running at real time priority cannot be paged out because of the
real time demand.

Is this true?

Thanks a lot,
Marcel

PS: please CC me personaly on replies
PPS: I'm hapy about every plausible idea
