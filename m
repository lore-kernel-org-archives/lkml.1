Return-Path: <linux-kernel-owner+w=401wt.eu-S1946017AbXBBS0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946017AbXBBS0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 13:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946018AbXBBS0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 13:26:19 -0500
Received: from muan.mtu.ru ([195.34.34.229]:1271 "EHLO muan.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946017AbXBBS0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 13:26:18 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH] libata: Fix (hopefully) all the remaining problems with devices failing setup/identify
To: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Date: Fri, 02 Feb 2007 21:23:53 +0300
References: <20070131172605.2c5dfc78@localhost.localdomain>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20070202182353.39A7539B9E3@muan.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:

> Two fixes in this test patch. One of them allows old CF cards to refuse
> pio mode setting, and one to wait for the drive to settle after a set
> features changes the speed settings, which is based upon the workarounds
> used by drivers/ide.
> 
> Please test and report back if you have an afflicted system. This patch
> isn't for merging just testing.
> 

Was it supposed to fix pata_ali failing to detect CD-ROM in DMA? Because it
did not (2.6.20-rc7 + this patch).

Thank you

-andrey

