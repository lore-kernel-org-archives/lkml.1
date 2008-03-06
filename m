Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYCFJZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYCFJZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbYCFJZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:25:05 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:26882 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751687AbYCFJZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:25:03 -0500
Date: Thu, 6 Mar 2008 18:24:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sh sh7710voipgw_defconfig compile error
Message-ID: <20080306092442.GA21177@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080303153843.GD26072@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303153843.GD26072@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 05:38:43PM +0200, Adrian Bunk wrote:
> It seems commit 9a7ef6d59f9d4780ff5bc9c4d05266b52dcb9211 broke the 
> support for this board:
> 
> <--  snip  -->
> 
> ...
>   CC      arch/sh/boards/renesas/sh7710voipgw/setup.o
> arch/sh/boards/renesas/sh7710voipgw/setup.c:15: error: array type has incomplete element type
> arch/sh/boards/renesas/sh7710voipgw/setup.c:16: error: 'TIMER2_IRQ' undeclared here (not in a function)
> arch/sh/boards/renesas/sh7710voipgw/setup.c:16: error: 'TIMER2_IPR_ADDR' undeclared here (not in a function)
> arch/sh/boards/renesas/sh7710voipgw/setup.c:16: error: 'TIMER2_IPR_POS' undeclared here (not in a function)
> arch/sh/boards/renesas/sh7710voipgw/setup.c:16: error: 'TIMER2_PRIORITY' undeclared here (not in a function)
> arch/sh/boards/renesas/sh7710voipgw/setup.c:17: error: 'WDT_IRQ' undeclared here (not in a function)
> arch/sh/boards/renesas/sh7710voipgw/setup.c:17: error: 'WDT_IPR_ADDR' undeclared here (not in a function)
> arch/sh/boards/renesas/sh7710voipgw/setup.c:17: error: 'WDT_IPR_POS' undeclared here (not in a function)
> arch/sh/boards/renesas/sh7710voipgw/setup.c:17: error: 'WDT_PRIORITY' undeclared here (not in a function)
> ...
> 
> <--  snip  -->
> 
Fixed now, this will go out with the -rc5 updates. Thanks.
