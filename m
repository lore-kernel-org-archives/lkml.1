Return-Path: <linux-kernel-owner+w=401wt.eu-S1030188AbXBPNsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030188AbXBPNsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964932AbXBPNsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:48:10 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:50607 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964845AbXBPNsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:48:08 -0500
Message-ID: <45D5B60F.7020104@ru.mvista.com>
Date: Fri, 16 Feb 2007 16:47:59 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marc St-Jean <stjeanma@pmc-sierra.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git master
References: <200702151926.l1FJQT2o020816@pasqua.pmc-sierra.bc.ca> <20070215171035.83918aae.akpm@linux-foundation.org>
In-Reply-To: <20070215171035.83918aae.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:

>>+			status = *(volatile u32 *)up->port.private_data;

> It distresses me that this patch uses a variable which this patch
> doesn't initialise anywhere.  It isn't complete.

    I assume this gets passed via early_serial_setup(). Marc?

> The sub-driver code whch sets up this field shuld be included in the
> patch, no?

    Hardly so, this code (not a subdriver) resides under arch/mips/ I think.

WBR, Sergei
