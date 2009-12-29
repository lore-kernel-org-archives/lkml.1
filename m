Return-Path: <linux-kernel-owner+w=401wt.eu-S1752508AbZL2BGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbZL2BGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 20:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZL2BGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 20:06:20 -0500
Received: from mailget.neusoft.com ([210.83.25.69]:64437 "EHLO
	mailgate.neusoft.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZL2BGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 20:06:19 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5845"; a="6482163"
Date: Tue, 29 Dec 2009 09:08:21 +0800 (CST)
From: fengxiangjun <fengxiangjun@neusoft.com>
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
In-reply-to: <4B388246.3040100@kernel.org>
X-X-Sender: fengxj@darkstar.example.net
To: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Message-id: <alpine.LNX.2.00.0912290904140.1689@darkstar.example.net>
MIME-version: 1.0
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net>
 <4B30134C.1050609@gmail.com>
 <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net>
 <51f3faa70912211708j200ab584wa835ffe50981415e@mail.gmail.com>
 <alpine.LNX.2.00.0912220955341.1696@darkstar.example.net>
 <4B31DB17.4050509@kernel.org>
 <alpine.LNX.2.00.0912231719440.1694@darkstar.example.net>
 <4B331957.7030906@kernel.org>
 <alpine.LNX.2.00.0912241535340.1682@darkstar.example.net>
 <4B331D93.2010000@kernel.org>
 <alpine.LNX.2.00.0912241557170.1682@darkstar.example.net>
 <alpine.LNX.2.00.0912242010350.1691@darkstar.example.net>
 <4B336153.8090206@kernel.org>
 <alpine.LNX.2.00.0912250931510.1680@darkstar.example.net>
 <4B34C097.1000206@kernel.org>
 <alpine.LNX.2.00.0912260919490.1729@darkstar.example.net>
 <4B388246.3040100@kernel.org>
Content-Transfer-Encoding: 7bit
Content-Type: TEXT/PLAIN; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> > Just reboot 3 times, and test STR, every thing works fine.
> > And the 3 reboots have the same message:
> > 
> > ata1.00: link resume succeeded after 1 retries
> 
> Cool, does it ever boot without the message?

Yesterday, the boot message has no such line(just boot 1 time).

Today, there is.

$ dmesg | grep ata1.00
ata1.00: link resume succeeded after 1 retries
ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: WDC WD800JD-60LSA5, 10.01E03, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48
ata1.00: configured for UDMA/100

Thanks.
---------------------------------------------------------------------------------------------------
Confidentiality Notice: The information contained in this e-mail and any accompanying attachment(s) 
is intended only for the use of the intended recipient and may be confidential and/or privileged of 
Neusoft Corporation, its subsidiaries and/or its affiliates. If any reader of this communication is 
not the intended recipient, unauthorized use, forwarding, printing,  storing, disclosure or copying 
is strictly prohibited, and may be unlawful.If you have received this communication in error,please 
immediately notify the sender by return e-mail, and delete the original message and all copies from 
your system. Thank you. 
---------------------------------------------------------------------------------------------------

