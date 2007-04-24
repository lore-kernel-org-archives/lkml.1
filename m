Return-Path: <linux-kernel-owner+w=401wt.eu-S1422927AbXDXRw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422927AbXDXRw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXDXRw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:52:59 -0400
Received: from inetc.connecttech.com ([64.7.140.42]:3525 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422919AbXDXRwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:52:44 -0400
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: <linux-kernel@vger.kernel.org>
Subject: Support for Zilog or Infineon hardware?
Date: Tue, 24 Apr 2007 13:54:33 -0400
Organization: Connect Tech Inc.
Message-ID: <000001c78699$9d92cb70$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have been investigating Linux support for the following chips:

Zilog		Z16C30 (also known as the "USC" or just 16C30)
Zilog		Z16C32 (also known as the "IUSC" or just 16C32)
http://www.zilog.com/products/family.asp?fam=200

Infineon	"SEROCCO" family
		SAB/SAF-20532 ("Serial Optimized Communications Controller")
		SAB/SAF-20542 ("Serial Optimized Communications Controller with DMA")
http://www.infineon.com/cgi-bin/ifx/portal/ep/channelView.do?channelId=-65034&channelPage=%2Fep%2Fchannel%2FleafNote.jsp&pageTypeId=
17099

I grepped 6.20 and 4.34 extensively, and found
drivers/char/synclink*.c which appear to use the 16C32. Google turned
up http://www.evolware.org/chri/serocco/index.html for the Infineon
chips, but it's an out-of-tree driver.

Is anyone aware of any other Linux drivers for those chips?

..Stu

