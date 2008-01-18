Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYAREkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYAREkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 23:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYAREkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 23:40:25 -0500
Received: from imsa.nihilent.com ([203.124.131.74]:52595 "EHLO
	imsa.nihilent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYAREkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 23:40:24 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Bitops source problem
Date: Fri, 18 Jan 2008 10:10:11 +0530
Message-ID: <1145971D427D7F43B0DBDAE22221C4B5035FDDAE@nipns00a210.FPS.NIHILENT.COM>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Bitops source problem
Thread-Index: AchZP7fg1PJ8zfYmRmK1hp5Nj+JCcwAS74gw
From: "Pravin Nanaware" <p.nanaware@nihilent.com>
To: "Roland Dreier" <rdreier@cisco.com>
Cc: "John Hubbard" <john.hubbard@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
X-TM-AS-Product-Ver: IMSS-7.0.0.1191-5.0.0.1023-15674.002
X-TM-AS-Result: No--11.831-7.0-31-1
X-imss-scan-details: No--11.831-7.0-31-1;No--11.831-7.0-31-1
X-TM-AS-User-Approved-Sender: No;No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a CentOS 4.4 system with 2.6.9-42 kernel. I will update the kernel to the new one. 

Regards,
Pravin


-----Original Message-----
From: Roland Dreier [mailto:rdreier@cisco.com]
Sent: Friday, January 18, 2008 1:03 AM
To: Pravin Nanaware
Cc: John Hubbard; LKML
Subject: Re: Bitops source problem


 > Yes, indeed none of the atomic bit operations functions has
 > LOCK_PREFIX in my version of Linux kernel.

You have a broken source tree then.  Where did your kernel source come
from then?  I'm not able to find any version of asm-i386/bitops.h
where clear_bit() doesn't have LOCK_PREFIX in any of the trees I
happen to have lying around  (which includes some very old trees like 2.4.21)

 - R.

-**************Nihilent***************
" *** All information contained in this communication is confidential, proprietary, privileged
and is intended for the addressees only. If youhave received this E-mail in error please notify
mail administrator by telephone on +91-20-39846100 or E-mail the sender by replying to
this message, and then delete this E-mail and other copies of it from your computer system.
Any unauthorized dissemination,publication, transfer or use of the contents of this communication,
with or without modifications is punishable under the relevant law.

Nihilent has scanned this mail with current virus checking technologies. However, Nihilent makes no 
representations or warranties to the effect that this communication is virus-free.

Nihilent reserves the right to monitor all E-mail communications through its Corporate Network. *** "

*************************************************************************-
