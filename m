Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYIYNzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYIYNzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 09:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYIYNzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 09:55:10 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:63917 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYIYNzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 09:55:09 -0400
Message-ID: <48DB9816.4020603@freescale.com>
Date: Thu, 25 Sep 2008 08:54:30 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Li Yang <leoli@freescale.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com
Subject: Re: [PATCH v2] fsl-dma: allow Freescale Elo DMA driver to be compiled
 as a module
References: <1222293567-17694-1-git-send-email-timur@freescale.com> <2a27d3730809242354u4cc24b96yda3973bfc3ddac92@mail.gmail.com>
In-Reply-To: <2a27d3730809242354u4cc24b96yda3973bfc3ddac92@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Yang wrote:

>> -subsys_initcall(of_fsl_dma_chan_init);
>>  subsys_initcall(of_fsl_dma_init);
> 
> Not a critical problem.  But module_init() are preferred for modules.

This was intentional.  When compiled as a module, subsys_initcall becomes
module_init().  When compiled in-kernel, this code is initialized before most
drivers, so it's ready when the drivers are loaded.

> Acked-by: Li Yang <leoli@freescale.com>

Thanks.

-- 
Timur Tabi
Linux kernel developer at Freescale
