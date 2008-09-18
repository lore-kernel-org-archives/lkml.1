Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbYIRWDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbYIRWDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYIRWDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:03:07 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:59542 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbYIRWDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:03:06 -0400
Message-ID: <48D2D00B.3010001@freescale.com>
Date: Thu, 18 Sep 2008 17:02:51 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Ira Snyder <iws@ovro.caltech.edu>
CC: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, leoli@freescale.com, zw@zh-kernel.org
Subject: Re: Problems with Freescale DMA driver
References: <20080825165133.GA20446@ovro.caltech.edu> <e9c3a7c20809181458p4cabccblfde6a92bf35976ee@mail.gmail.com>
In-Reply-To: <e9c3a7c20809181458p4cabccblfde6a92bf35976ee@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> [adding Timur to the cc]
> 
> On Mon, Aug 25, 2008 at 9:51 AM, Ira Snyder <iws@ovro.caltech.edu> wrote:
>> Hello LKML,
>>
>> I'm developing on a Freescale MPC8349EA MDS evaluation board. I'm
>> currently testing the DMA controller. It uses the CONFIG_FSL_DMA driver.
>>
>> All tests were done with a recent git pull.

I just posted two patches lkml that affect the FSL DMA driver:

[PATCH v2] dmatest: properly handle duplicate DMA channels
[PATCH] fsl-dma: allow Freescale Elo DMA driver to be compiled as a module

Could you apply them both and re-run the tests?

I will also try to duplicate this here on an 8360.

-- 
Timur Tabi
Linux kernel developer at Freescale
