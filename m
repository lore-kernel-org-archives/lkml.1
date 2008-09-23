Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbYIWQuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbYIWQuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbYIWQqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:46:33 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:65468 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbYIWQqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:46:32 -0400
Message-ID: <48D91D61.2080800@freescale.com>
Date: Tue, 23 Sep 2008 11:46:25 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Ira Snyder <iws@ovro.caltech.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problems with Freescale DMA driver
References: <20080825165133.GA20446@ovro.caltech.edu> <e9c3a7c20809181458p4cabccblfde6a92bf35976ee@mail.gmail.com> <48D2D00B.3010001@freescale.com> <20080922230435.GA20825@ovro.caltech.edu> <48D8F73A.4050004@freescale.com> <20080923155935.GA7449@ovro.caltech.edu> <48D914DD.7080702@freescale.com> <20080923164322.GC7449@ovro.caltech.edu>
In-Reply-To: <20080923164322.GC7449@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ira Snyder wrote:

> In this case, I probably would like to reserve a DMA channel for my
> exclusive use. That way I won't run into problems by programming the DMA
> by hand.

If you write your own DMA driver, the current method for reserving a DMA channel
is to change the compatible property for that channel in the device tree to
something other than "fsl,elo-dma-channel" (or "fsl,eloplus-dma-channel").

-- 
Timur Tabi
Linux kernel developer at Freescale
