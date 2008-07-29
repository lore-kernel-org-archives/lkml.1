Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYG2F4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYG2F4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbYG2F4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:56:31 -0400
Received: from mail.renesas.com ([202.234.163.13]:38163 "EHLO
	mail01.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754477AbYG2F43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:56:29 -0400
X-AuditID: ac140384-0000000900000ffd-cd-488eabb1094a
Date: Tue, 29 Jul 2008 14:33:37 +0900
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: Re: sh se7750_defconfig compile error
In-reply-to: <20080728214039.GE7713@cs181140183.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <488EABB1.2070008@renesas.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=UTF-8
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
References: <20080728214039.GE7713@cs181140183.pp.htv.fi>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Adrian.

Thank you for your check and report.

I will fix this soon.

Best regards,
  Nobuhiro

Adrian Bunk wrote:
> Commit ffb91ad2751723bcc9925cd38e37013e2169e256
> (sh: Solution Enginge 7710/7712 SH-Ether support)
> causes the following compile error with se7750_defconfig:
> 
> <--  snip  -->
> 
> ...
>   CC      arch/sh/boards/se/770x/setup.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/boards/se/770x/setup.c:134: error: 'PHY_ID' undeclared here (not in a function)
> make[2]: *** [arch/sh/boards/se/770x/setup.o] Error 1
> 
> <--  snip  -->
> 
> The patch did:
> #if defined(CONFIG_CPU_SUBTYPE_SH7710)
> # define PHY_ID 0x00
> #elif defined(CONFIG_CPU_SUBTYPE_SH7712)
> # define PHY_ID 0x01
> #endif
> 
> But in this case we have CONFIG_CPU_SUBTYPE_SH7750.
> 
> cu
> Adrian
> 

