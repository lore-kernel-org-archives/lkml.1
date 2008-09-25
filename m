Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbYIYN62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbYIYN62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 09:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYIYN6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 09:58:21 -0400
Received: from oslproxyp1.tandberg.com ([194.0.215.2]:41187 "EHLO
	oslproxyp1.tandberg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYIYN6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 09:58:20 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Re: D945GCLF  intel atom board & r8169 ethernet broken in linux-2.6.27-rc5??
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 25 Sep 2008 15:58:17 +0200
Message-ID: <9F6ACAE02B6DD040A1E259977622CFDB03F5C24B@oslexcp1.eu.tandberg.int>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: D945GCLF  intel atom board & r8169 ethernet broken in linux-2.6.27-rc5??
Thread-Index: AckeOFvaMeK2OhXFQcWGhCCuFr63ngA3YPwg
From: "John Gumb" <john.gumb@tandberg.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Sep 2008 13:58:18.0274 (UTC) FILETIME=[C3474820:01C91F16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My fault

linux-2.6.27-rc7 fixes this. I should have tested this.

Thanks to all who responded with fixes.

John

-----Original Message-----
From: John Gumb 
Sent: 24 September 2008 12:26
To: linux-kernel@vger.kernel.org
Cc: 'netdev@vger.kernel.org'
Subject: D945GCLF intel atom board & r8169 ethernet broken in
linux-2.6.27-rc5??

Hi

I have an Intel Atom D945GCLF based system. It has a realtek RTL8101E
PCI network interface.

With linux-2.6.27-rc4 - everything seems fine. I think we've been
working OK since 2.6.26ish.

With linux-2.6.27-rc5, "ifconfig eth0" just hangs. lspci -vvx reports,
after loading the driver,

> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E
PCI Express Fast Ethernet controller (rev ff) (prog-if ff)
>       !!! Unknown header type 7f
00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  

Before I load the driver lspci -vvx looks OK.

I do not have (much) time to look into this any further but hopefully
this might help someone.

I know there are problems with this device on the atom board
particularly around warm start but thus far I seem to have avoided this
issue.

A cold start in this case does not help.

Lspci.bad comes from -rc5 with the r8169 driver loaded.
Lspci.good comes from -rc4 with the r8169 driver loaded

Cheers

John
