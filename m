Return-Path: <linux-kernel-owner+w=401wt.eu-S936655AbYEURYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936655AbYEURYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936250AbYEURVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:21:09 -0400
Received: from mail.fieldses.org ([66.93.2.214]:35900 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936196AbYEURVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:21:07 -0400
Date: Wed, 21 May 2008 13:21:04 -0400
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.24 not recognizing 2G MMC card?
Message-ID: <20080521172104.GC2592@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please forgive a somewhat naive question--I'm not sure how to go about
debugging this kind of thing:

I have a Dell 1420n with card readers reported by lspci as:

03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
03:01.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)

I have a 512MB MicroSD card which seems to be recognized fine, but a 2GB
MMC card is not.

I'm using a stock Ubuntu 8.04 kernel, which reports itself as
2.6.24-16-generic.

Skimming through commits to drivers/mmc,
5ae70296c85f96a9969891d9de3410ebdf210b71 "mmc: Disabler for Ricoh MMC
controller", looks relevant, but seems to be included in 2.6.24.

Anything I should try?  Thanks in advance for any suggestions.

--b.
