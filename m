Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYIROtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYIROtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYIROte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:49:34 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:34176 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYIROtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:49:33 -0400
Message-ID: <48D26A74.4030104@freescale.com>
Date: Thu, 18 Sep 2008 09:49:24 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: Dan Williams <dan.j.williams@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
References: <48D02589.8070601@freescale.com>	<e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>	<ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>	<20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>	<48D2664D.7040204@freescale.com> <20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:

> I guess so. What would be even more simple is to simply prevent other
> clients from taking a channel once someone has acked it, which would be
> perfect for my purposes, but perhaps not everyone else's...

I'm not clear on how your driver works, but doesn't it run continuous tests on
all channels all the time?  If so, wouldn't your proposal prevent other drivers
from ever getting a DMA channel?

-- 
Timur Tabi
Linux kernel developer at Freescale
