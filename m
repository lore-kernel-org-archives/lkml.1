Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYHRORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYHRORU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYHRORG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:17:06 -0400
Received: from p01c12o145.mxlogic.net ([208.65.145.68]:53089 "EHLO
	p01c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYHRORF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:17:05 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Linux 2.6.26 edac errors and ASUS P5W DH Deluxe motherboard
Date: Mon, 18 Aug 2008 15:17:01 +0100
Message-ID: <0F10A59FDFFDFD4E9BEBD7365DE672550214F027@uk-email.terastack.bluearc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linux 2.6.26 edac errors and ASUS P5W DH Deluxe motherboard
Thread-Index: AckBPRUPfalAtn12SI2RQV13wrXFuQ==
From: "Andy Chittenden" <andyc@bluearc.com>
To: <linux-kernel@vger.kernel.org>
X-Spam: [F=0.1000000000; S=0.100(2008081101)]
X-MAIL-FROM: <andyc@bluearc.com>
X-SOURCE-IP: [62.190.48.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just installed the linux-image-2.6.26-1-amd64 debian package on
three of our ASUS P5W DH Deluxe based machines and they've all started
spewing out messages:

Message from syslogd@savage at Mon Aug 18 14:01:52 2008 ...
savage kernel: [   74.389644] EDAC MC0: UE page 0x7fe03, offset 0x0,
grain 128, row 2, labels ":": i82975x UE

Message from syslogd@savage at Mon Aug 18 14:01:53 2008 ...
savage kernel: [   75.555862] EDAC MC0: UE page 0x7fd44, offset 0x0,
grain 128, row 2, labels ":": i82975x UE

Message from syslogd@savage at Mon Aug 18 14:01:54 2008 ...
savage kernel: [   76.628039] EDAC MC0: UE page 0x7fd41, offset 0x0,
grain 128, row 2, labels ":": i82975x UE

Message from syslogd@savage at Mon Aug 18 14:01:55 2008 ...
savage kernel: [   77.629260] EDAC MC0: UE page 0x7fd27, offset 0x0,
grain 128, row 2, labels ":": i82975x UE

every second.

I've removed that kernel package and they're running previous versions
of the kernel (eg linux-image-2.6.25-2-amd64) happily. I've run memtest
on one of them with no problems. So, anyone got any ideas what's causing
this? (FWIW the machines have all got ECC memory in them).

-- 
Andy, BlueArc Engineering


