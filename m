Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbZFYEZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbZFYEZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 00:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFYEZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 00:25:49 -0400
Received: from 219-87-157-155.static.tfn.net.tw ([219.87.157.155]:13750 "EHLO
	ironport.rdc.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750762AbZFYEZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 00:25:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] pata_rdc: driver for RDC ATA devices
Date: Thu, 25 Jun 2009 12:27:18 +0800
Message-ID: <07905E0D268758488D76D7D747F21BB602B4ED3B@rdc8.rdc>
In-Reply-To: <20090624235548.681b8992@lxorguk.ukuu.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] pata_rdc: driver for RDC ATA devices
Thread-Index: Acn1Hxal5iugcUqQR6uuxEveWaa9qQAJQH8g
References: <20090624172930.24354.80799.stgit@t61.ukuu.org.uk><4A42800D.6020202@garzik.org> <20090624235548.681b8992@lxorguk.ukuu.org.uk>
From: =?big5?B?S2V2aW4gSHVhbmcgKLbAs82k5Sk=?= <Kevin.Huang@rdc.com.tw>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>
Cc: <linux-kernel@vger.kernel.org>, <greg@kroah.com>,
       "Linux IDE mailing list" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset="big5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5P4Qg54010477

At first I studied ata_piix driver for our driver, because we need to testing our controller. Then I found it is hard to me.I needed to clearify the unreadable code of hardware setting and configuration.So I just modify and clean up original code. And make it simple for beginner or maintainer. I keep original framework and design for future controllers and updates.
This is my first experience of linux driver . Just for share.

-----Original Message----->> Seems fine and fairly straightforward to me.  My lone comment -- go >> through and replace magic numbers with named constants, for e.g. the PCI >> config registers that program timings...
>Its based on your ata_piix driver. Feel free to update that and I'll pull>names and things across to match.---------------------------------------------------------------------------------- [E-mail Confidentiality Notice]The information in this e-mail is confidential and may be legally privileged otherwise  protected from disclosure. It is intended solely for the addressee.  Access to this e-mail by anyone else is unauthorized .If youare not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and maybe unlawful.  Please delete the message and any attachments from your computer system; and destroy all hard copies. 
ALL Intellectual Property Rights of RDC Reserved.---------------------------------------------------------------------------------- ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
