Return-Path: <linux-kernel-owner+w=401wt.eu-S1763636AbXK2SBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636AbXK2SBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763134AbXK2SAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:00:54 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50053 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762602AbXK2SAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:00:54 -0500
Date: Thu, 29 Nov 2007 19:00:52 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Kyle McMartin <kyle@mcmartin.ca>
cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       avuton@gmail.com, hancockr@shaw.ca, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, mrmacman_g4@mac.com, dean@arctic.org,
       argggh@dolphinics.no, shdl@zakalwe.fi, vlobanov@speakeasy.net,
       drzeus-list@drzeus.cx, strange@nsk.no-ip.org, dm.n9107@gmail.com,
       johannes@sipsolutions.net
Subject: Re: [RFC v2] Documentation about unaligned memory access
In-Reply-To: <20071129170436.GA2754@fattire.cabal.ca>
Message-ID: <Pine.LNX.4.64.0711291859330.13075@fbirervta.pbzchgretzou.qr>
References: <20071129161523.E0C349D4B52@zog.reactivated.net>
 <20071129170436.GA2754@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 29 2007 12:04, Kyle McMartin wrote:
>
>For example, if you had 4GB of virtual memory, picture it as an
>array of bytes,
>	u8 memory[4096 * (1024 * 1024)];	/* 4G bytes */

uint8_t memory[4096UL * 1024 * 1024];

>Aligned accesses would be accessing this array in this manner,
>	u16 memory[(4096 * (1024 * 1024)) / sizeof(u16)] /* 2G bytes */
>	u32 memory[(4096 * (1024 * 1024)) / sizeof(u32)] /* 1G bytes */
>	u64 memory[(4096 * (1024 * 1024)) / sizeof(u64)] /* 512M bytes */

	u64 memory[4096UL * 1024 * 1024 / sizeof(u64)] /* 4G too */
