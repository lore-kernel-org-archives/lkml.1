Return-Path: <linux-kernel-owner+w=401wt.eu-S965417AbXDBNam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965417AbXDBNam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 09:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965425AbXDBNam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 09:30:42 -0400
Received: from inetc.connecttech.com ([64.7.140.42]:3013 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965417AbXDBNal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 09:30:41 -0400
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: "'Aaron Lehmann'" <aaronl@vitelus.com>, "'Jim Paris'" <jim@jtan.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: RE: Silent corruption on AMD64
Date: Mon, 2 Apr 2007 09:30:18 -0400
Organization: Connect Tech Inc.
Message-ID: <003c01c7752b$0e678fa0$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <20070401043905.GV15189@vitelus.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: On Behalf Of Aaron Lehmann
> I've been able to narrow it down to the Realtek Ethernet card. I can't
> reproduce the problem using onboard Ethernet, whereas the Realtek card
> causes trouble in any slot. However, I still don't know whether it's a
> hardware or software issue, or whether it's caused directly or
> indirectly by the Realtek card.

I had a similar issue recently:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=223216

I recommend trying Doug Ledford's memtest script:
http://people.redhat.com/dledford/memtest.html

It helped me prove the issue was the hardware and not something else.

..Stu

