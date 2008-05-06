Return-Path: <linux-kernel-owner+w=401wt.eu-S1765699AbYEFWAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765699AbYEFWAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYEFV7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:59:48 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:57796 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbYEFV7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:59:45 -0400
Message-ID: <005b01c8afc4$77f4ec90$6401a8c0@techwriter>
From: "Yigal Sadgat" <YSadgat1@gcte.com>
To: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
Cc: <jwboyer@linux.vnet.ibm.com>, <joern@logfs.org>
Subject: Compact Flash Question
Date: Tue, 6 May 2008 14:59:33 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We wrote the Kernel to support CF drives (in IDE mode) several years ago but
now there are strange things coming back from the field that compel us to go
back and re-evaluate many design decisions.

For instance,
(1) Can you really ignore bit(2) (CORR) in the Status register offset 7 that 
tells
you that the CF has detected and corrected a soft error?, etc.
(2) An engineer at SanDisk Engineering told me NOT to do wear leveling.
The file allocation table is written very frequently back into the flash. So
is it really safe to assume that I don't need wear leveling???
(3) Re. the BUSY bit in the status register (offset 7, bit D7), anybody 
experienced
time outs?
(4) Re Error register (offset 1) bit D7 (BBK), again, I was told that it 
cannot (???)
happen since the CF performs read-after-write and it automatically switches 
good blocks
for bad ones... Is this correct?

We get many "soft" errors and I cannot wait to put my hand on a system to 
test but
thought I would draw on your collective experience before we dive into these 
issues again.

Any comments would be greatly appreciated.

Yigal Sadgat
General Computer Technology (GCT)
YSadgat1@gcte.com



