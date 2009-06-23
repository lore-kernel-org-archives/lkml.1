Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbZFWCmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbZFWCmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZFWCmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:42:31 -0400
Received: from 219-87-157-155.static.tfn.net.tw ([219.87.157.155]:46788 "EHLO
	ironport.rdc.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751811AbZFWCmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:42:31 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: Staging: add pata_rdc driver
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Tue, 23 Jun 2009 10:44:03 +0800
Message-ID: <07905E0D268758488D76D7D747F21BB602B1FDA8@rdc8.rdc>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Staging: add pata_rdc driver
Thread-Index: AcnzNYoeAiPEgTO0Tta3LeCIMwvhLQAbaFjgAAIjZyA=
References: <200906200109.n5K19iaC012636@hera.kernel.org> <20090622133222.3a689f22@lxorguk.ukuu.org.uk> 
From: =?big5?B?S2V2aW4gSHVhbmcgKLbAs82k5Sk=?= <Kevin.Huang@rdc.com.tw>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: <greg@kroah.com>, <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="big5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5N2hG54008431

I just know all pata follow the ATA ATAPI Host Adapters Standard.pdf.This standard describes all hardware interfaces for pata. (like sata and AHCI standard spec.)
The original draft does not have any Configuration Registers for Host Adapters. Then Intel proposes ATA Controller PCI Configuration Registers for this lack of the original draft, and T13 accept this proposal.
But this spec. releases at 2003. So before its release, all vendor had own Configuration Registers.
[Kevin Huang] -> According to this spec. OS can provide a standard driver for different vendor's pata controller.
Our new controller have crypto function and crypto configuration registers.So it don¡¦t like Intel controller.Some Intel controller have RAID function, but we have not.
---------------------------------------------------------------------------------- [E-mail Confidentiality Notice]The information in this e-mail is confidential and may be legally privileged otherwise  protected from disclosure. It is intended solely for the addressee.  Access to this e-mail by anyone else is unauthorized .If youare not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and maybe unlawful.  Please delete the message and any attachments from your computer system; and destroy all hard copies. 
ALL Intellectual Property Rights of RDC Reserved.---------------------------------------------------------------------------------- ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
