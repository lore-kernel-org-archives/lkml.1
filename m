Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbZLVBAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbZLVBAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZLVBAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:00:46 -0500
Received: from mailget.neusoft.com ([210.83.25.69]:18959 "EHLO
	mailgate.neusoft.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZLVBAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:00:45 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5839"; a="5113841"
Date: Tue, 22 Dec 2009 09:02:57 +0800 (CST)
From: fengxiangjun <fengxiangjun@neusoft.com>
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
In-reply-to: <4B30134C.1050609@gmail.com>
X-X-Sender: fengxj@darkstar.example.net
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net>
MIME-version: 1.0
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net>
 <4B30134C.1050609@gmail.com>
Content-Transfer-Encoding: 7bit
Content-Type: TEXT/PLAIN; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yeah, running 2.6.32.1 now, no problem.

dmesg shows:

ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)

When booting 2.6.32.2 with the same config, I get

ata1.00: SATA link down (SStatus 0 SControl 301)

Weird.

On Mon, 21 Dec 2009, Robert Hancock wrote:

> On 12/21/2009 05:12 AM, fengxiangjun wrote:
> > 
> > Hi,
> > 
> > after upgrading to 2.6.32.2,
> > with the attached config,
> > kernel booting always(just tried 10+ times) failed at:
> > 
> > ata1.00: SATA link down (SStatus 0 SControl 301)
> > ...
> > VFS: Cannot open root device ...
> 
> There were no libata changes in 2.6.32.2 that should have affected this. Are
> you sure the .config is unchanged? Have you rechecked that 2.6.31.1 still
> works?
> 
---------------------------------------------------------------------------------------------------
Confidentiality Notice: The information contained in this e-mail and any accompanying attachment(s) 
is intended only for the use of the intended recipient and may be confidential and/or privileged of 
Neusoft Corporation, its subsidiaries and/or its affiliates. If any reader of this communication is 
not the intended recipient, unauthorized use, forwarding, printing,  storing, disclosure or copying 
is strictly prohibited, and may be unlawful.If you have received this communication in error,please 
immediately notify the sender by return e-mail, and delete the original message and all copies from 
your system. Thank you. 
---------------------------------------------------------------------------------------------------

