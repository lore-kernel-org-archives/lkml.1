Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZEWJSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZEWJSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 05:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZEWJSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 05:18:13 -0400
Received: from smtp.nokia.com ([192.100.105.134]:41617 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZEWJSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 05:18:12 -0400
Subject: Re: [PATCH] MTD: Remove pmcmsp-ramroot.c
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-mips@linux-mips.org,
       dwmw2@infradead.org, hch@lst.de, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, Marc St-Jean <stjeanma@pmc-sierra.com>
In-Reply-To: <E1M0HJu-0007HN-7j@localhost>
References: <E1M0HJu-0007HN-7j@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 May 2009 12:17:26 +0300
Message-Id: <1243070246.21646.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 May 2009 09:17:29.0255 (UTC) FILETIME=[4B9F0370:01C9DB87]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-02 at 09:40 -0600, Shane McDonald wrote:
> The RAMROOT function was a successful but non-portable attempt to append
> the root filesystem to the end of the kernel image.  The preferred and
> portable solution is to use an initramfs instead.
> 
> The only user of this function was the msp71xx configuration
> in the MIPS architecture; as the use of the RAMROOT has been removed
> from that configuration, there are no more users, so this code
> can be removed.

I've taken this patch to l2-mtd-2.6.git.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

