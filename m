Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbXIXP6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbXIXP6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXIXP6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:58:44 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:58675 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbXIXP6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:58:43 -0400
Message-ID: <46F7DE85.7000401@freescale.com>
Date: Mon, 24 Sep 2007 10:57:57 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH4/4] [POWERPC] Fix cpm_uart driver
References: <46F6C9DC.90008@scram.de>
In-Reply-To: <46F6C9DC.90008@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> 
> In cpm_uart_core, functions cpm_uart_init_bd and cpm_uart_init_scc
> an offset into DP RAM is calculated by substracting a physical
> memory constant from an virtual address. This patch fixes the
> problem by converting the virtual address into a physical
> first.

Huh?  DPRAM_BASE is a virtual address.  With this patch, you'd be 
subtracting a virtual address from a physical address.

-Scott
