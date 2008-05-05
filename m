Return-Path: <linux-kernel-owner+w=401wt.eu-S1762815AbYEEVdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762815AbYEEVdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759976AbYEEVcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:32:47 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:51777 "EHLO
	outbound2-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758240AbYEEVcp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:32:45 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 07/56] microblaze_v2: Signal support
Date: Mon, 5 May 2008 14:32:45 -0700
In-reply-to: <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 07/56] microblaze_v2: Signal support
Thread-Index: Aciujy71PhccAjECScS5EtNJWeeZogAaFfDw
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: <monstr@seznam.cz>, <linux-kernel@vger.kernel.org>
Cc: <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
       "John Linn" <linnj@xilinx.com>, <john.williams@petalogix.com>,
       <matthew@wil.cx>, <will.newton@gmail.com>, <drepper@redhat.com>,
       <microblaze-uclinux@itee.uq.edu.au>, <grant.likely@secretlab.ca>,
       "Michal Simek" <monstr@monstr.eu>
X-OriginalArrivalTime: 05 May 2008 21:32:44.0031 (UTC) FILETIME=[8DDD60F0:01C8AEF7]
Message-Id: <20080505213244.8DC757A0084@mail70-wa4.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(multiple places)  can this code (and flush_cache_sigtramp()) go away?

+#if 0
+		flush_cache_sigtramp((unsigned long)frame->tramp);
+#endif


