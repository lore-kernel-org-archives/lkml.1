Return-Path: <linux-kernel-owner+w=401wt.eu-S1764165AbXHDD5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764165AbXHDD5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 23:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762625AbXHDD5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 23:57:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57984
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762394AbXHDD5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 23:57:10 -0400
Date: Fri, 03 Aug 2007 20:57:09 -0700 (PDT)
Message-Id: <20070803.205709.126573435.davem@davemloft.net>
To: mchan@broadcom.com
Cc: joachim.deguara@amd.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       netdev@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [REGRESSION] tg3 dead after s2ram
From: David Miller <davem@davemloft.net>
In-Reply-To: <1186081829.18322.20.camel@dell>
References: <200708021115.10812.joachim.deguara@amd.com>
	<20070802.022317.66176729.davem@davemloft.net>
	<1186081829.18322.20.camel@dell>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Thu, 02 Aug 2007 12:10:29 -0700

> [TG3]: Fix suspend/resume problem.
> 
> Joachim Deguara <joachim.deguara@amd.com> reported that tg3 devices
> would not resume properly if the device was shutdown before the system
> was suspended.  In such scenario where the netif_running state is 0,
> tg3_suspend() would not save the PCI state and so the memory enable bit
> and bus master enable bit would be lost.
> 
> We fix this by always saving and restoring the PCI state in
> tg3_suspend() and tg3_resume() regardless of netif_running() state.
> 
> Signed-off-by: Michael Chan <mchan@broadcom.com>

Patch applied.
