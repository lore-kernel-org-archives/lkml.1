Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbYGOCSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbYGOCSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbYGOCR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:17:28 -0400
Received: from cnrelay03.alcatel-sbell.com.cn ([211.144.215.19]:46445 "EHLO
	mail.alcatel-sbell.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756037AbYGOCR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:17:27 -0400
Message-ID: <487C08B6.5000301@alcatel-lucent.com>
Date: Tue, 15 Jul 2008 10:17:26 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: DMA timeout on PIIX4
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2008 02:17:22.0892 (UTC) 
	FILETIME=[EA9340C0:01C8E620]
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scores: Clean:0.79253 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:2 C:1 M:1 S:1 R:1 (0.1500 0.1500)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, There has one PIIX4 IDE controller on my board. When I uncompressed
a large tar file (almost 1.7GB) from one partition to another one, following
errors were reported at middle way. Was it really caused by "lost 
interrupt"?
It means target didn't make response to master who initialized DMA request?

hdc: dma_timer_expiry: dma status == 0x24
hdc: DMA interrupt recovery
hdc: lost interrupt

